<?php
require_once 'Zend/Session/Namespace.php';

class VD_Controller_Plugin_Acl extends Zend_Controller_Plugin_Abstract
{

	public function preDispatch(Zend_Controller_Request_Abstract $request)
	{
		$auth = Zend_Auth::getInstance();
        if ($auth->hasIdentity()) {
        	$identity = $auth->getIdentity();
            $role = $identity['role'];
        } else {
            $role = VD_Constants::$ROLE_GUEST;
        }
        
		$acl = Zend_Registry::get('acl');
		$actionName = $request->getActionName();
		$controllerName = $request->getControllerName();
		$privilegeName = $controllerName . '/' . $actionName;
        
		if(!$acl->isAllowed($role, null, $privilegeName)) {
            $redirector = Zend_Controller_Action_HelperBroker::getStaticHelper('Redirector');
            $redirector->gotoUrlAndExit('/');
		}
	}

}
