<?php
class Zend_View_Helper_BaseUrl 
{   
    /**
     *  Get base url
     * 
     * @return string
     */
    public function baseUrl($path = '')
    {
        return rtrim(Zend_Controller_Front::getInstance()->getBaseUrl(),'/').'/'.$path;
    }

}