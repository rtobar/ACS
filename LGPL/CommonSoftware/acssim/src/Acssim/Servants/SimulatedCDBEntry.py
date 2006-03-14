# @(#) $Id: SimulatedCDBEntry.py,v 1.3 2006/03/14 23:59:06 dfugate Exp $
#
# Copyright (C) 2001
# Associated Universities, Inc. Washington DC, USA.
#
# Produced for the ALMA project
#
# This library is free software; you can redistribute it and/or modify it under
# the terms of the GNU Library General Public License as published by the Free
# Software Foundation; either version 2 of the License, or (at your option) any
# later version.
#
# This library is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU Library General Public License for more
# details.
#
# You should have received a copy of the GNU Library General Public License
# along with this library; if not, write to the Free Software Foundation, Inc.,
# 675 Massachusetts Ave, Cambridge, MA 02139, USA.  Correspondence concerning
# ALMA should be addressed as follows:
#
# Internet email: alma-sw-admin@nrao.edu
# "@(#) $Id: SimulatedCDBEntry.py,v 1.3 2006/03/14 23:59:06 dfugate Exp $"
#
# who       when        what
# --------  ----------  -------------------------------------------------------
# dfugate   2003/12/09  Created.
#------------------------------------------------------------------------------
'''
TODO:

'''
#--REGULAR IMPORTS-------------------------------------------------------------
from operator import isSequenceType
#--CORBA STUBS-----------------------------------------------------------------

#--ACS Imports-----------------------------------------------------------------
from Acssim.Servants.Goodies import getComponentXMLObj
from Acssim.Servants.SimulatedEntry import SimulatedEntry
#--GLOBALS---------------------------------------------------------------------

#------------------------------------------------------------------------------
class SimulatedCDBEntry(SimulatedEntry):
    '''
    Class derived from SimulatedEntry to be used only with the CDB. In other words,
    this class searches the CDB for entries describing method/attribute return
    values.
    '''
    #--------------------------------------------------------------------------
    def __init__ (self, compname, supported_interfaces = []):
        '''
        Constructor.

        Paramters:
        - compname is the name of the component being simulated
        - supported_interfaces is an optional list of IDL interfaces which 
        this particular component supports.
        
        Returns: Nothing

        Raises: ???
        '''
        #superclass constructor
        SimulatedEntry.__init__(self, compname)
        
        #bool value showing whether the CDB entry exists or not
        self.exists=0
        
        #determine if this simulated component allows inheritence
        allows_inheritence = self.handleCDBEntry(self.compname)
        
        if allows_inheritence:
            #look at all supported IDL interfaces first
            self.handleInterfaces(supported_interfaces)
            
    #--------------------------------------------------------------------------
    def handleCDBEntry(self, name):
        '''
        Handles an individual CDB entry. This means that if parameter, "name",
        exists within the ACS CDB; we take all info found within the CDB XML
        and add it to this object instance overriding previous 
        method/attribute defininitions where applicable.
        
        Parameters: name is the name of the CDB XML within the /alma/simulated
        section we're searching for.
        
        Returns: True if the current XML allows us to look at superinterfaces.
        False otherwise.
        
        Raises: Nothing
        '''
        ret_val = True
        
        #create an xml helper object
        xml_obj = getComponentXMLObj(name)
        
        if xml_obj!=None:
            #at least one entry exists. good!
            self.exists = 1
            
            #get the corba methods
            self.getCorbaMethods(xml_obj)

            #get the corba attributes
            self.getCorbaAttributes(xml_obj)
            
            #allow inheritance?
            ret_val = xml_obj.SimulatedComponent.getAttribute('AllowInheritance')
            
        return ret_val
    #--------------------------------------------------------------------------
    def handleInterfaces(self, supported_interfaces):
        '''
        Add behavior from derived interfaces for the concrete IDL interface. 
        
        Parameters: supported_interfaces is a list of IDL interface IDs. 
        Arrangement should matter - IDL does not support overriding 
        method declarations in subinterfaces. A simple list could be:
            [ 'IDL:/alma/FRIDGE/FridgeControl:1.0', 
              'IDL:/alma/ACS/CharacteristicComponent:1.0']
        
        Returns: Nothing
        
        Raises: ???
        '''
        #convert the names in supported_interfaces to actual CDB locations
        for supported_interface in supported_interfaces:
            cdb_location = "interfaces/"
            #Turn "IDL:alma/someModule/someInterface:1.0" into:
            #"alma/someModule/someInterface/1.0/1.0"
            supported_interface = supported_interface.split('IDL:')[1].replace(":", "/")
            cdb_location = cdb_location + supported_interface
            
            #now try to extract some useful info
            self.handleCDBEntry(cdb_location)
            
    #--------------------------------------------------------------------------
    def getCorbaMethods(self, xml_obj):
        '''
        '''
        #methods is the somewhat formatted data taken from the XML. not really
        #nice enough to work with yet.
        try:
            methods = xml_obj.SimulatedComponent._corbaMethod
            if isSequenceType(methods)==0:
                methods = [ methods ]
        except:
            return

        #for each method in the list
        for dom in methods:
            #dictionary defining the method
            tDict = {}

            #extract the method name
            methname = dom.getAttribute('Name')

            #set the timeout
            tDict['Timeout'] = float(dom.getAttribute('Timeout'))

            #get the code to be executed yielding a return value
            tDict['Value'] = dom.getValue().rstrip().lstrip().split('\n')
        
            #save the dictionary
            self.setMethod(methname, tDict)
    #--------------------------------------------------------------------------
    def getCorbaAttributes(self, xml_obj):
        '''
        '''
        #attributes is the somewhat formatted data taken from the XML. not really
        #nice enough to work with yet.
        try:
            attributes = xml_obj.SimulatedComponent._corbaAttribute
            if isSequenceType(attributes)==0:
                attributes = [ attributes ]
        except:
            return

        #for each method in the list
        for dom in attributes:
            #dictionary defining the attribute
            tDict = {}

            #extract the attribute name
            attrname = dom.getAttribute('Name')

            #set the timeout
            tDict['Timeout'] = float(dom.getAttribute('Timeout'))

            #get the code to be executed yielding a return value
            tDict['Value'] = dom.getValue().rstrip().lstrip().split('\n')
        
            #save the dictionary
            self.setMethod(attrname, tDict)
    #--------------------------------------------------------------------------
