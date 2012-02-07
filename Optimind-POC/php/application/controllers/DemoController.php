<?php

class DemoController extends Zend_Controller_Action
{

    public function init()
    {
        /* Initialize action controller here */
    }

    public function indexAction()
    {
        // action body
    }

    public function formsAction()
    {
        // action body
        $this->view->headTitle()->append('Forms');
    }

    public function stylesAction()
    {
        // action body
        $this->view->headTitle()->append('Styles');
    }

    public function tablesAction()
    {
        // action body
        $this->view->headTitle()->append('Tables');
    }

    public function gridAction()
    {
        // action body
        $this->view->headTitle()->append('Grid System');
    }

    public function widgetsAction()
    {
        // action body
        $this->view->headTitle()->append('Widgets');
    }

    public function wysiwygAction()
    {
        // action body
        $this->view->headTitle()->append('WYSIWYG');
    }

    public function naviconsAction()
    {
        // action body
        $this->view->headTitle()->append('Navicons');
    }


}















