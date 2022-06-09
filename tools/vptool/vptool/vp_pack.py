#############################################################################
#
# Copyright 2022 Thales
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#############################################################################
#
# Original Authors:
#
#     Zbigniew CHAMSKI (zbigniew.chamski@thalesgroup.com)
#     Vincent MIGAIROU (vincent.migairou@thalesgroup.com)
#
#############################################################################
## Config is Project dependent. It is imported from platform_package
## PYTHON_PATH env variable could be used

import sys
from datetime import datetime

try:
	from vp_config import *
except Exception as e:
	print("ERROR: Please define path to vp_config package (got %s!)" % str(e))
	sys.exit()

# Remove non-ASCII characters from a string.
def remove_non_ascii(s): return "".join([x for x in s if ord(x)<128])

#####################################
##### Class Definition
class Item:
	"""
		An item defines a specific case to test depending on its parent property
		It is intended to be instantiated in Prop class
	"""
	count=0
	def __init__(self,item_ref_name=0,tag="",description="",purpose=""):
		self.name = str(item_ref_name)
		self.tag = tag
		self.description = description
		self.purpose = purpose
		self.verif_goals = ''
		self.coverage_loc = ''
		# FIXME: Propagate default value from YAML config.
		self.pfc = -1  # none selected, must choose
		self.test_type = -1  # none selected, must choose
		self.cov_method = -1  # none selected, must choose
		self.cores = -1 # applicable to all cores
		self.comments = ''
		self.status = ''
		self.simu_target_list = []
		self.__class__.count +=1
		#self.lock = 0
		self.rfu_list = []
		#self.rfu_list_2 = []
		self.rfu_dict = {}	# used as lock. will be updated with class update
		self.rfu_dict['lock_status']=0
	def __del__(self):
		self.__class__.count -=1
	def get_verif_status(self):   # FIXME: remove?
		if self.status == "" or int(self.status) == 3 or int(self.status) == 4:
			returned_status = 0
		else:
			returned_status = int(self.status)
		if returned_status == 1:
			is_verified_text=" Waived"
		elif returned_status == 2:
			is_verified_text=" Standalone"
		elif returned_status == 0 and not self.simu_target_list:
			is_verified_text=" Not Done"
		else:
			is_verified_text=" Implemented"
		return [returned_status,is_verified_text]
	def is_implemented(self):
		returned_status=False
		if self.status == '' or int(self.status) == 0 or int(self.status) == 3 :
			if self.simu_target_list:
				returned_status=True
		return(returned_status)
	def is_vip(self):
		returned_status=False
		if self.status:
			if int(self.status) == 3 :
				returned_status=True
		return(returned_status)
	def is_assert(self):
		returned_status=False
		if self.status:
			if int(self.status) == 4 :
				returned_status=True
		return(returned_status)
	def get_status(self):
		returned_status=0
		if self.status:
			returned_status=int(self.status)
		return(returned_status)
	def invert_lock(self):
		if self.is_locked():
			self.rfu_dict['lock_status']=0
		else:
			self.rfu_dict['lock_status']=" ".join((str(datetime.now()),os.getlogin()))
	def unlock(self):
		self.rfu_dict['lock_status']=0
	def lock(self):
		self.rfu_dict['lock_status']=" ".join((str(datetime.now()),os.getlogin()))
	def is_locked(self):
		return bool(self.rfu_dict['lock_status'])
	def get_lock_status(self):
		return str(self.rfu_dict['lock_status'])
	@staticmethod
	def is_tag_valid(text):  # FIXME: remove
		is_tag=False
		regex_tag = re.compile (r'VP_IP[0-9][0-9][0-9]_P[0-9][0-9][0-9]_I[0-9][0-9][0-9]$')
		if regex_tag.match(text):
			is_tag=True
		return is_tag
class Prop:
	"""
		A Property defines a specific behaviour or an IP section, to be tested/verified
		It is intended to be instantiated in Ip class.
		It contains a collection of Items.	
	"""
	def __init__(self,name="",tag="",wid_order=0):
		self.item_count = 0			# determine how many items have been created for a given property
		self.name = name
		self.tag = tag
		self.item_list = {}
		self.wid_order = wid_order
		## rfu for future dev
		self.rfu_list = []
		self.rfu_list_1 = []
		self.rfu_list_2 = []
		self.rfu_dict = {}
	def prop_clone(self):
		new_prop=Prop()
		new_prop.item_count=self.item_count
		new_prop.name = self.name
		new_prop.tag = self.tag
		new_prop.item_list = self.item_list.copy()
		new_prop.wid_order = self.wid_order
		new_prop.rfu_list = self.rfu_list[:]
		new_prop.rfu_list_1 = self.rfu_list_1[:]
		new_prop.rfu_list_2 = self.rfu_list_2[:]
		new_prop.rfu_dict = self.rfu_dict.copy()
		return new_prop	
	def add_item(self,tag,description="",purpose=""):			# adds an item to Prop
#		self.item_list[self.item_count]=(Item(str(self.item_count),tag=tag+"_item"+str(self.item_count)))
		self.item_list[str(self.item_count).zfill(3)]=(Item(str(self.item_count).zfill(3),tag=tag+"_I"+str(self.item_count).zfill(3),description=description,purpose=purpose))
		self.item_count+=1
	def del_item(self,index):		# remove an item from Prop
		if index == max(self.item_list.keys()) and False: # Spare numbering option disabled by False statement.
			self.item_count-=1		# if the element removed is the last one, one can decrement item_count to spare numbering
		del self.item_list[index]
	def get_item_name(self):
		item_list_name = []
		for item in self.item_list:
			item_list_name.append(item.name)
		return item_list_name
	def prep_to_save(self):
		"""
			Trick used to ensure pickle output file stability
			Pickle doesn't provide reproductible output for dict. When saved, they are converted to list
		"""
		self.rfu_list = sorted(list(self.item_list.items()),key= lambda key: key[0])
		self.item_list = {}
	def post_load(self):
		"""
			Trick used to ensure pickle output file stability
			When loading saved db, list are converted back to initial dict
		"""
		for item_key,item_elt in self.rfu_list:
			self.item_list[item_key]=item_elt
		self.rfu_list = []
	def insert_item(self,item_name):
		""" This is intended to be used in specific cases as it
			can changes every item numbering; Should not be used ater item is implemented in simulations
			It insert last item in self.item_list at insert index, and update item tag and name accordingly
		"""
		insert_index=int(item_name)+1
		updated_dict={}
		insert_index_string=str(insert_index).zfill(3)
		to_insert=self.item_list.pop(max(self.item_list.keys()))
		for elt in list(self.item_list.keys()):
			if int(elt)<insert_index:
				updated_dict[elt]=self.item_list[elt]
			else:
				updated_dict[str(int(elt)+1).zfill(3)]=self.item_list[elt]
				updated_dict[str(int(elt)+1).zfill(3)].tag=updated_dict[str(int(elt)+1).zfill(3)].tag[:-3]+str(int(elt)+1).zfill(3)
				updated_dict[str(int(elt)+1).zfill(3)].name=str(int(elt)+1).zfill(3)
		updated_dict[insert_index_string]=to_insert
		updated_dict[insert_index_string].tag=updated_dict[insert_index_string].tag[:-3]+insert_index_string
		updated_dict[insert_index_string].name=insert_index_string
		self.item_list=updated_dict
	def unlock_items(self):
		for item in list(self.item_list.values()):
			item.unlock()
	def lock_items(self):
		for item in list(self.item_list.values()):
			item.lock()

class Ip:	
	"""
		An IP defines a bloc instantiated at chip top level, or more generally, a design specification chapter
		needing to be covered by a verification plan.
		It contains a collection of Prop.	
	"""
	_ip_count=0
	def __init__(self,name="",index=""):
		self.prop_count = 0			# determine how many prop have been created for a given IP
		self.name = name
		self.prop_list = {}
		if index:		
			self.ip_num = index	## Store number creation 
		else:
			self.ip_num = self.__class__._ip_count
		self.__class__._ip_count +=1
		self.wid_order = self.ip_num
		# rfu for future dev
		self.rfu_dict = {}
		self.rfu_list = []
		self.rfu_list_0 = []
		self.rfu_list_1 = []
	def add_property(self,name,tag="",custom_num=""):				# adds an Prop instance to Ip
		if name in list(self.prop_list.keys()):
			print("Property already exists")
			feedback = 0
		else:
			name=remove_non_ascii(name)
			prop_name=custom_num+str(self.prop_count).zfill(3)+"_"+str(name)
			#self.prop_list[prop_name] = Prop(prop_name,tag=tag.replace(' ','').replace('/','')+str(self.prop_count)+"_"+name.replace(' ','').replace('/',''))
			self.prop_list[prop_name] = Prop(prop_name,tag="VP_IP"+str(self.ip_num).zfill(3)+"_P"+str(self.prop_count).zfill(3),wid_order=self.prop_count)
			feedback = self.prop_list[prop_name].tag
			self.prop_count += 1		
		return (feedback,prop_name)
	def del_property(self,name):				# remove a Prop instance from Ip
		##if name == max(self.prop_list.keys()):  # if the element removed is the last one, one can decrement item_count to spare numbering
		if self.prop_count == int(self.prop_list[name].tag[-3:])+1:  # with custom numbering max elt is not always the last one created
			self.prop_count-=1
		del self.prop_list[str(name)]
	def clear(self):
		self.__class__._ip_count = 0
	def unlock_properties(self):
		"""
			Unlock all Prop/Items of the IP
		"""
		for prop in list(self.prop_list.values()):
			prop.unlock_items()
	def lock_properties(self):
		"""
			Lock all Prop/Items of the IP
		"""
		for prop in list(self.prop_list.values()):
			prop.lock_items()
	def unlock_ip(self):
		"""
			Unlock all Prop/Items of the IP.
		"""
		self.unlock_properties()
	def prep_to_save(self):
		"""
			Trick used to ensure pickle output file stability
			Pickle doesn't provide reproductible output for dict. When saved, they are converted to list
		"""
		self.rfu_list = sorted(list(self.prop_list.items()),key= lambda key: key[0])
		self.prop_list = {}
	def post_load(self):
		"""
			Trick used to ensure pickle output file stability
			When loading saved db, list are converted back to initial dict
		"""
		for prop_key,prop_elt in self.rfu_list:
			self.prop_list[prop_key]=prop_elt
		self.rfu_list = []
	def create_ip_tag_dict(self):
		ip_tag_dict={}
		for prop in list(self.prop_list.values()):
			for item in list(prop.item_list.values()):
				ip_tag_dict[item.tag]=item
		return ip_tag_dict
