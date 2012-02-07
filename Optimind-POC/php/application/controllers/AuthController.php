<?php

class AuthController extends Zend_Controller_Action
{
    public function init()
    {
        $this->_helper->viewRenderer->setNoRender();
    }

    public function indexAction()
    {
        // action body
    }

    public function loginAction()
    {
    	$auth = Zend_Auth::getInstance();
    	
    	$username = $this->getRequest()->getParam("username");
    	$password = $this->getRequest()->getParam("password");
    	$authAdapter = new VD_AuthAdapter($username, $password);
    	
    	// Attempt authentication, saving the result
        $result = $auth->authenticate($authAdapter);
        if (!$result->isValid()) {
            echo "INVALID";
            $this->_redirect('/index');
        } else {
            echo "VALID";
            Zend_Session::rememberMe(60*60*24*30);
            $this->_redirect('/dashboard');
        }
    }

    public function logoutAction()
    {
    	//Remove the authenticated user session
        $auth = Zend_Auth::getInstance();
        $auth->clearIdentity();
        $this->_redirect("/");
    }

}





