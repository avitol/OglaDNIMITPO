<?php

class IndexController extends Zend_Controller_Action
{

    public function init()
    {
        /* Initialize action controller here */
    }

    public function indexAction()
    {
        $this->_helper->layout->disableLayout();
        
        if (Zend_Auth::getInstance()->hasIdentity()) {
            $this->_helper->redirector('index', 'dashboard');
        }
    }


}


