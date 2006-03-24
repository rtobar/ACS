template<class TReceiverCallback, class TSenderCallback>
BulkDataDistributerImpl<TReceiverCallback, TSenderCallback>::BulkDataDistributerImpl(const ACE_CString& name,ContainerServices* containerServices) : 
    CharacteristicComponentImpl(name,containerServices)
{
    ACS_TRACE("BulkDataDistributerImpl<>::BulkDataDistributerImpl");

    containerServices_p=containerServices;

    dal_p = containerServices_p->getCDB();
    if (CORBA::is_nil (dal_p))
	{
	ACS_SHORT_LOG((LM_INFO,"BulkDataDistributerImpl::connect dal_p nil"));
	AVStreamEndpointErrorExImpl err = AVStreamEndpointErrorExImpl(__FILE__,__LINE__,"BulkDataDistributerImpl::connect");
	throw err.getAVStreamEndpointErrorEx();
	}
}


template<class TReceiverCallback, class TSenderCallback>
BulkDataDistributerImpl<TReceiverCallback, TSenderCallback>::~BulkDataDistributerImpl()
{
    ACS_TRACE("BulkDataDistributerImpl<>::~BulkDataDistributerImpl");
}


template<class TReceiverCallback, class TSenderCallback>
void BulkDataDistributerImpl<TReceiverCallback, TSenderCallback>::cleanUp()
{
    ACS_TRACE("BulkDataDistributerImpl<>::cleanUp");
}


/**************************** Sender part *****************************************/

template<class TReceiverCallback, class TSenderCallback>
void BulkDataDistributerImpl<TReceiverCallback, TSenderCallback>::connect(bulkdata::BulkDataReceiver_ptr receiverObj_p)
    throw (CORBA::SystemException, AVConnectErrorEx)
{
    ACS_TRACE("BulkDataDistributerImpl<>::connect");

    // single connect not allowed
    ACS_SHORT_LOG((LM_INFO,"BulkDataDistributerImpl::connect AVFlowEndpointErrorExImpl SINGLE CONNECTION NOT ALLOWED"));
    AVConnectErrorExImpl err = AVConnectErrorExImpl(__FILE__,__LINE__,"BulkDataDistributerImpl::connect");
    throw err.getAVConnectErrorEx();

}




template<class TReceiverCallback, class TSenderCallback>
void BulkDataDistributerImpl<TReceiverCallback, TSenderCallback>::multiConnect(bulkdata::BulkDataReceiver_ptr receiverObj_p)
    throw (CORBA::SystemException, AVConnectErrorEx)
{
    ACS_TRACE("BulkDataDistributerImpl<>::multiConnect");


    char buf[BUFSIZ];

    try
	{

	ACE_CString CDBpath="alma/";
	CDBpath += name();

	CDB::DAO_ptr dao_p = dal_p->get_DAO_Servant(CDBpath.c_str());
	if (CORBA::is_nil (dao_p))
	    {
	    ACS_SHORT_LOG((LM_INFO,"BulkDataDistributerImpl::connect dao_p nil"));
	    AVStreamEndpointErrorExImpl err = AVStreamEndpointErrorExImpl(__FILE__,__LINE__,"BulkDataDistributerImpl::connect");
	    throw err.getAVStreamEndpointErrorEx();
	    }

	ACE_OS::strcpy(buf,dao_p->get_string("sender_protocols"));
	}
    catch(...)
	{
	ACS_SHORT_LOG((LM_WARNING,"BulkDataDistributerImpl::connect CDB failure."));
	AVConnectErrorExImpl err = AVConnectErrorExImpl(__FILE__,__LINE__,"BulkDataDistributerImpl::connect");
	throw err.getAVConnectErrorEx();
	}

    try
	{

	receiverObj_p->openReceiver();

	bulkdata::BulkDataReceiverConfig *receiverConfig = receiverObj_p->getReceiverConfig();
	if(receiverConfig == 0)
	    {
	    ACS_SHORT_LOG((LM_INFO, "BulkDataDistributerImpl::connect AVReceiverConfigErrorExImpl - receiverConfig NULL"));
	    throw AVReceiverConfigErrorExImpl(__FILE__,__LINE__,"BulkDataDistributerImpl::connect");
	    }

	ACE_CString recvName = receiverObj_p->name();

	distributer.multiConnect(receiverConfig,buf,recvName);
	}

    catch (AVInitErrorExImpl & ex)
	{   
	ACS_SHORT_LOG((LM_INFO, "BulkDataDistributerImpl::connect AVInitErrorExImpl exception catched !"));
	AVConnectErrorExImpl err = AVConnectErrorExImpl(ex,__FILE__,__LINE__,"BulkDataDistributerImpl::connect");
	throw err.getAVConnectErrorEx();
	}
    catch (AVStreamEndpointErrorExImpl & ex)
	{   
	ACS_SHORT_LOG((LM_INFO, "BulkDataDistributerImpl::connect AVStreamEndpointErrorExImpl exception catched !"));
	AVConnectErrorExImpl err = AVConnectErrorExImpl(ex,__FILE__,__LINE__,"BulkDataDistributerImpl::connect");
	throw err.getAVConnectErrorEx();
	}
    catch (AVFlowEndpointErrorExImpl & ex)
	{   
	ACS_SHORT_LOG((LM_INFO,"BulkDataDistributerImpl::connect AVFlowEndpointErrorExImpl exception catched !"));
	AVConnectErrorExImpl err = AVConnectErrorExImpl(ex,__FILE__,__LINE__,"BulkDataDistributerImpl::connect");
	throw err.getAVConnectErrorEx();
	}
    catch (AVOpenReceiverErrorEx & ex)
	{   
	ACS_SHORT_LOG((LM_INFO,"BulkDataDistributerImpl::connect AVOpenReceiverErrorEx exception catched !"));
	AVConnectErrorExImpl err = AVConnectErrorExImpl(ex,__FILE__,__LINE__,"BulkDataDistributerImpl::connect");
	throw err.getAVConnectErrorEx();
	}
    catch (AVReceiverConfigErrorEx & ex)
	{   
	ACS_SHORT_LOG((LM_INFO,"BulkDataDistributerImpl::init AVReceiverConfigErrorEx exception catched !"));
	AVConnectErrorExImpl err = AVConnectErrorExImpl(ex,__FILE__,__LINE__,"BulkDataDistributerImpl::connect");
	throw err.getAVConnectErrorEx();
	}
    catch (AVReceiverConfigErrorExImpl & ex)
	{   
	ACS_SHORT_LOG((LM_INFO,"BulkDataDistributerImpl::init AVReceiverConfigErrorExImpl exception catched !"));
	AVConnectErrorExImpl err = AVConnectErrorExImpl(ex,__FILE__,__LINE__,"BulkDataDistributerImpl::connect");
	throw err.getAVConnectErrorEx();
	}
    catch (AVStreamBindErrorExImpl & ex)
	{   
	ACS_SHORT_LOG((LM_INFO,"BulkDataDistributerImpl::init AVStreamBindErrorExImpl exception catched !"));
	AVConnectErrorExImpl err = AVConnectErrorExImpl(ex,__FILE__,__LINE__,"BulkDataDistributerImpl::connect");
	throw err.getAVConnectErrorEx();
	}
    catch(...)
	{
	ACS_SHORT_LOG((LM_INFO,"BulkDataDistributerImpl::connect UNKNOWN exception"));
	AVConnectErrorExImpl err = AVConnectErrorExImpl(__FILE__,__LINE__,"BulkDataDistributerImpl::connect");
	throw err.getAVConnectErrorEx();
	}



}


template<class TReceiverCallback, class TSenderCallback>
void BulkDataDistributerImpl<TReceiverCallback, TSenderCallback>::disconnect()
    throw (CORBA::SystemException, AVDisconnectErrorEx)
{
    ACS_TRACE("BulkDataDistributerImpl<>::disconnect");
}



template<class TReceiverCallback, class TSenderCallback>
void BulkDataDistributerImpl<TReceiverCallback, TSenderCallback>::multiDisconnect(bulkdata::BulkDataReceiver_ptr receiverObj_p)
    throw (CORBA::SystemException)
{
    
    ACE_CString recvName = receiverObj_p->name();

    try
	{
	distributer.multiDisconnect(recvName);
	}
    catch(...)
	{
	AVDisconnectErrorExImpl err = AVDisconnectErrorExImpl(__FILE__,__LINE__,"BulkDataDistributerImpl::disconnect");
	throw err.getAVDisconnectErrorEx();
	}
 }


template<class TReceiverCallback, class TSenderCallback>
void BulkDataDistributerImpl<TReceiverCallback, TSenderCallback>::startSend()
    throw (CORBA::SystemException, AVStartSendErrorEx)
{
    ACS_TRACE("BulkDataDistributerImpl<>::startSend");
}


template<class TReceiverCallback, class TSenderCallback>
void BulkDataDistributerImpl<TReceiverCallback, TSenderCallback>::paceData()
    throw (CORBA::SystemException, AVPaceDataErrorEx)
{
    ACS_TRACE("BulkDataDistributerImpl<>::paceData");
}


template<class TReceiverCallback, class TSenderCallback>
void BulkDataDistributerImpl<TReceiverCallback, TSenderCallback>::stopSend()
    throw (CORBA::SystemException, AVStopSendErrorEx)
{
    ACS_TRACE("BulkDataDistributerImpl<>::stopSend");
}


template<class TReceiverCallback, class TSenderCallback>
void BulkDataDistributerImpl<TReceiverCallback, TSenderCallback>::openReceiver()
    throw (CORBA::SystemException, AVOpenReceiverErrorEx)
{
    ACS_TRACE("BulkDataDistributerImpl<>::openReceiver");
  
    char buf[BUFSIZ];

    try
	{

	ACE_CString CDBpath="alma/";
	CDBpath += name();

	CDB::DAO_ptr dao_p = dal_p->get_DAO_Servant(CDBpath.c_str());
	if (CORBA::is_nil (dao_p))
	    {
	    ACS_SHORT_LOG((LM_INFO,"BulkDataDistributerImpl<>::openReceiver dao_p nil"));
	    AVStreamEndpointErrorExImpl err = AVStreamEndpointErrorExImpl(__FILE__,__LINE__,"BulkDataDistributerImpl::openReceiver");
	    throw err.getAVStreamEndpointErrorEx();
	    }

	ACE_OS::strcpy(buf,dao_p->get_string("recv_protocols"));
	}
    catch(...)
	{
	ACS_SHORT_LOG((LM_WARNING,"BulkDataDistributerImpl<>::openReceiver CDB failure."));
	AVOpenReceiverErrorExImpl err = AVOpenReceiverErrorExImpl(__FILE__,__LINE__,"BulkDataDistributerImpl::openReceiver");
	throw err.getAVOpenReceiverErrorEx();	
	}

    try
	{
	distributer.getReceiver()->initialize();

	distributer.getReceiver()->createMultipleFlows(buf);
	}

    catch (AVInitErrorExImpl & ex)
	{   
	ACS_SHORT_LOG((LM_INFO,"BulkDataDistributerImpl<>::openReceiver AVInitErrorEx exception catched !"));
	AVOpenReceiverErrorExImpl err = AVOpenReceiverErrorExImpl(ex,__FILE__,__LINE__,"BulkDataDistributerImpl::openReceiver");
	throw err.getAVOpenReceiverErrorEx();
	}
    catch (AVStreamEndpointErrorExImpl & ex)
	{   
	ACS_SHORT_LOG((LM_INFO,"BulkDataDistributerImpl<>::openReceiver AVStreamEndpointErrorEx exception catched !"));
	AVOpenReceiverErrorExImpl err = AVOpenReceiverErrorExImpl(ex,__FILE__,__LINE__,"BulkDataDistributerImpl::openReceiver");
	throw err.getAVOpenReceiverErrorEx();
	}
    catch (AVFlowEndpointErrorExImpl & ex)
	{   
	ACS_SHORT_LOG((LM_INFO,"BulkDataDistributerImpl<>::openReceiver AVFlowEndpointErrorEx exception catched !"));
	AVOpenReceiverErrorExImpl err = AVOpenReceiverErrorExImpl(ex,__FILE__,__LINE__,"BulkDataDistributerImpl::openReceiver");
	throw err.getAVOpenReceiverErrorEx();
	}
    catch(...)
	{
	ACS_SHORT_LOG((LM_INFO,"BulkDataDistributerImpl<>::openReceiver UNKNOWN exception"));
	AVOpenReceiverErrorExImpl err = AVOpenReceiverErrorExImpl(__FILE__,__LINE__,"BulkDataDistributerImpl::openReceiver");
	throw err.getAVOpenReceiverErrorEx();
	}
}


template<class TReceiverCallback, class TSenderCallback>
bulkdata::BulkDataReceiverConfig * BulkDataDistributerImpl<TReceiverCallback, TSenderCallback>::getReceiverConfig()
    throw (CORBA::SystemException, AVReceiverConfigErrorEx)
{
    ACS_TRACE("BulkDataDistributerImpl<>::getReceiverConfig");

    bulkdata::BulkDataReceiverConfig *receiverConfig = 0;
    try
	{
	receiverConfig = distributer.getReceiver()->getReceiverConfig();
	}
    catch(AVReceiverConfigErrorExImpl & ex)
	{
	throw ex.getAVReceiverConfigErrorEx();
	}

    return receiverConfig;
}


template<class TReceiverCallback, class TSenderCallback>
void BulkDataDistributerImpl<TReceiverCallback, TSenderCallback>::closeReceiver()
    throw (CORBA::SystemException, AVCloseReceiverErrorEx)
{
    ACS_TRACE("BulkDataDistributerImpl<>::closeReceiver");

    try
	{
	distributer.getReceiver()->closeReceiver();
	}
    catch(...)
	{
	AVCloseReceiverErrorExImpl err = AVCloseReceiverErrorExImpl(__FILE__,__LINE__,"BulkDataDistributerImpl::closeReceiver");
	throw err.getAVCloseReceiverErrorEx();
	}
}


template<class TReceiverCallback, class TSenderCallback>
void BulkDataDistributerImpl<TReceiverCallback, TSenderCallback>::setReceiver(const bulkdata::BulkDataReceiverConfig &receiverConfig)
    throw (CORBA::SystemException)
{
    ACS_TRACE("BulkDataDistributerImpl<>::setReceiver");

    CORBA::ULong dim = receiverConfig.fepsInfo.length();
    
// loop on all flows
    for(CORBA::ULong i = 0; i < dim; i++)
	{ 
	ACE_CString flw = TAO_AV_Core::get_flowname(receiverConfig.fepsInfo[i]);

	TReceiverCallback *cb = 0;	 
	distributer.getReceiver()->getFlowCallback(flw, cb);
	if(cb == 0)
	    {
// TBD what to do
	    ACS_SHORT_LOG((LM_INFO,"BulkDataDistributerImpl<>::setReceiver - distributer callback = 0"));
	    } 
	else
	    {
	    ACS_SHORT_LOG((LM_DEBUG,"BulkDataDistributerImpl<>::setReceiver - distributer callback OK"));
	    cb->setDistributerImpl(this);
	    }	    
	}
}


template<class TReceiverCallback, class TSenderCallback>
ACSErr::Completion * BulkDataDistributerImpl<TReceiverCallback, TSenderCallback>::getCbStatus(CORBA::ULong flowNumber) 
    throw (CORBA::SystemException, AVInvalidFlowNumberEx)
{
    ACS_TRACE("BulkDataDistributerImpl<>::getCbStatus");
    

    TReceiverCallback *cb = 0;

    try
	{
	getDistributer()->getReceiver()->getFlowCallback(flowNumber,cb);
	}
    catch(AVInvalidFlowNumberExImpl & ex)
	{
	throw ex.getAVInvalidFlowNumberEx();
	}

    if(cb->isTimeout() && cb->isWorking())
	{
	AVCbWorkingTimeoutCompletion *comp = new AVCbWorkingTimeoutCompletion();
	//comp->log();
	return comp->returnCompletion();
	}
    if(cb->isTimeout())
	{
	AVCbTimeoutCompletion *comp = new AVCbTimeoutCompletion();
	//comp->log();
	return comp->returnCompletion();
	}
    if(cb->isWorking())
	{
	AVCbWorkingCompletion *comp = new AVCbWorkingCompletion();
	//comp->log();
	return comp->returnCompletion();
	}	
    
    AVCbReadyCompletion *comp = new AVCbReadyCompletion();
    //comp->log();

    return comp->returnCompletion();
}


template<class TReceiverCallback, class TSenderCallback>
ACSErr::Completion * BulkDataDistributerImpl<TReceiverCallback, TSenderCallback>::getReceiverCbStatus(const char *recvName, CORBA::ULong flowNumber) 
    throw (CORBA::SystemException)
{
    ACS_TRACE("BulkDataDistributerImpl<>::getReceiverCbStatus");

    bulkdata::BulkDataReceiver_var receiver = containerServices_p->getComponent<bulkdata::BulkDataReceiver>(recvName);
    if(!CORBA::is_nil(receiver.in()))
	{
	return receiver->getCbStatus(flowNumber);
	}
    
    AVCbNotAvailableCompletion *comp = new AVCbNotAvailableCompletion();
    return comp->returnCompletion();
}
