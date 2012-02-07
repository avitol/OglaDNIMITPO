<?php
class VD_AuthAdapter implements Zend_Auth_Adapter_Interface
{
	private $username;
	private $password;
	
	/**
	* Sets username and password for authentication
	*
	* @return void
	*/
	public function __construct($username, $password)
	{
		$this->username = $username;
		$this->password = $password;		
	}
	
	/**
	* Performs an authentication attempt
	*
	* @throws Zend_Auth_Adapter_Exception If authentication cannot
	*         be performed
	* @return Zend_Auth_Result
	*/
	public function authenticate()
	{
		if( !isset($this->username) 
			|| !isset($this->password) 
			|| empty($this->username) 
			|| empty($this->password) ){
        	return new Zend_Auth_Result(
        		Zend_Auth_Result::FAILURE_CREDENTIAL_INVALID,
				array(),
				array('Invalid Authorization'));
		}
        
		// @TODO This is just an adapter template, it's up to you to put in your sql code using zend_db
        $entity = false;
        $entity->username = "administrator";
        $entity->firstname = "John";
        $entity->lastname = "Doe";
        $entity->user_role = "admin";
	
		if(!empty($entity)){
			$identity = array(
                'username' => $this->username,
                'firstname' => $entity->firstname,
                'lastname' => $entity->lastname,
                'role' => $entity->user_role
			);
			
			return new Zend_Auth_Result(Zend_Auth_Result::SUCCESS, $identity, array());	
		}

		return new Zend_Auth_Result(
			Zend_Auth_Result::FAILURE_CREDENTIAL_INVALID,
			array(),
			array('Invalid Authorization'));
	}
}
