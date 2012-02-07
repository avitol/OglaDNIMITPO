<?php
class VD_Controller_Helper_Acl
{
	public $acl;
	public function __construct()
	{
		$this->acl = new Zend_Acl();
	}
	
	public function setRoles()
	{
		$guest = new Zend_Acl_Role(VD_Constants::$ROLE_GUEST);
		$this->acl
            ->addRole($guest)
            ->addRole(new Zend_Acl_Role(VD_Constants::$ROLE_USER), $guest)
            ->addRole(new Zend_Acl_Role(VD_Constants::$ROLE_ADMIN));
        
        return $this;
	}

	public function setResources()
	{
        return $this;
	}

	public function setPrivileges()
	{
		$this->acl
            ->deny(VD_Constants::$ROLE_GUEST, null, null)
            ->allow(VD_Constants::$ROLE_GUEST, null, array('index/index', 'auth/login'))
            ->allow(VD_Constants::$ROLE_USER)
            ->allow(VD_Constants::$ROLE_ADMIN);
        
        return $this;
	}
	
	public function setAcl()
	{
		Zend_Registry::set('acl', $this->acl);
        
        return $this;
	}
	
}
