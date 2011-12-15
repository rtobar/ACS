#ifndef _BULK_DATA_NT_CONFIGURATION_H_
#define _BULK_DATA_NT_CONFIGURATION_H_

/*******************************************************************************
* ALMA - Atacama Large Millimiter Array
* (c) European Southern Observatory, 2011
*
* This library is free software; you can redistribute it and/or
* modify it under the terms of the GNU Lesser General Public
* License as published by the Free Software Foundation; either
* version 2.1 of the License, or (at your option) any later version.
*
* This library is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* Lesser General Public License for more details.
*
* You should have received a copy of the GNU Lesser General Public
* License along with this library; if not, write to the Free Software
* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307  USA
*
* "@(#) $Id: bulkDataNTConfiguration.h,v 1.21 2011/12/15 15:10:47 bjeram Exp $"
*
* who       when        what
* --------  ---------   ----------------------------------------------
* rtobar    011-08-01   created
*/

#ifndef __cplusplus
#error This is a C++ include file and cannot be used from plain C
#endif

#include <map>
#include <string>

namespace AcsBulkdata
{

///DDS configuration class at this moment it is common for all configuration classes but can be later split
// ... if needed
class DDSConfiguration
{
	friend class BulkDataNTDDS;
	friend class BulkDataNTStream;
	friend class BulkDataNTDDSSubscriber;
	friend class BulkDataNTDDSPublisher;
	friend class BulkDataConfigurationParser;
public:
	DDSConfiguration();

	/**
	 * Default qos_library to use
	 */
	static const char* const DEFAULT_LIBRARY;

	/**
	 * Default qos_profile to use for sender streams
	 */
	static const char* const DEFAULT_SENDER_STREAM_PROFILE;

	/**
	 * Default qos_profile to use for sender flows
	 */
	static const char* const DEFAULT_SENDER_FLOW_PROFILE;

	/**
	 * Default qos_profile to use for receiver streams
	 */
	static const char* const DEFAULT_RECEIVER_STREAM_PROFILE;

	/**
	 * Default qos_profile to use for receiver flows
	 */
	static const char* const DEFAULT_RECEIVER_FLOW_PROFILE;

protected:
	std::string libraryQos;  /// QoS configuration library
	std::string profileQos;  /// QoS configuration profile in the library that should be used

	std::string stringProfileQoS;  /// her goes DDS QoS Profile

	// QoS that follow can be hardcoded, but is more flexible in this way.
	bool ignoreUserProfileQoS; //when true USER_QOS_PROFILES.xml in current folder would not be loaded
	bool ignoreEnvironmentProfileQoS; //when true NDDS_QOS_PROFILES will be ignored
};


/// common class for Sender and Receiver configuration
class StreamConfiguration : public DDSConfiguration
{
	friend class BulkDataNTStream;
	friend class BulkDataConfigurationParser;
public:
	StreamConfiguration();

	static const char* const DEFAULT_QoS_FILE;

	unsigned int DDSLogVerbosity; // log level for RTI DDS, the type should be NDDS_Config_LogVerbosity

protected:
	void fillUrlProfileQoS(const char* envVar, const char *dilim="");

	bool participantPerStream;  /// TBD: not used yet - should flag if we have a participant per stream or just a single participant
	std::string urlProfileQoS;   // here we specify where it should be looked for default values = DEFAULT_QoS_FILE
};


/****************************************/
/* Sender-side configuration structures */
/****************************************/

/** A Sender flow configuration */
class  SenderFlowConfiguration : public DDSConfiguration
{
public:
	SenderFlowConfiguration();
	double frameTimeout;
	double ACKsTimeout;  /// TBD:: not used yet
};

/** A Sender stream configuration. It consists in a seres
 *  of sender flow configurations */
class SenderStreamConfiguration : public StreamConfiguration
{
public:
	SenderStreamConfiguration();

	//	std::map<const char *, BulkDataNTSenderFlowConfiguration> flows;
};


/******************************************/
/* Receiver-side configuration structures */
/******************************************/

/** Specifies the kind of a receiver. This information is propagated
 *  to the senders so they can take decision based on the importance
 *  of the receiver, in case of any problem. */
enum ReceiverType {
	NORMAL    = 0x1,
	IMPORTANT = 0x2,
	CRITICAL  = 0x4
};

/** A Receiver flow configuration */
class ReceiverFlowConfiguration : public DDSConfiguration
{
public:
	ReceiverFlowConfiguration();
};

/** A Receiver stream configuration. It consists in a seres
 *  of receiver flow configurations, and also of the receiver type */
class ReceiverStreamConfiguration : public StreamConfiguration
{
public:

	ReceiverStreamConfiguration();

protected:
	ReceiverType type;
	//	std::map<const char *, BulkDataNTReceiverFlowConfiguration> flows;
};

};

#endif /*!_H*/
