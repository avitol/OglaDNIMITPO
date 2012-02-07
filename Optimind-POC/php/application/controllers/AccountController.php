<?php

class AccountController extends Zend_Controller_Action
{

    public function init()
    {
        /* Initialize action controller here */
    }

    public function indexAction()
    {
        // action body
        $this->view->headTitle()->append('Account');
    }

    public function themesAction()
    {
        $this->view->headTitle()->append('Themes');
        
        if (!empty($_GET["activatetheme"])) {
            setcookie('theme', $_GET["activatetheme"], time() + 3600 * 24 * 365 * 10 /* expire in 10 years */, '/');
            setcookie('css', '', time() - 3600, '/');
            $this->_helper->redirector("themes", "account");
        }
        $this->view->currentthemeinfo = $this->getCurrentThemeInfo();
        $this->view->themes = $this->getThemes();
        $this->view->colors = $this->getColors();
        $this->view->backgrounds = $this->getFiles(BASE_PATH . '/images/backgrounds', 'jpg|png');
    }

    public function getFiles($directory, $type = '*')
    {
        $results = array();
        $handler = opendir($directory);
        while ($file = readdir($handler)) {
            if ($file != "." && $file != ".." && preg_match("/\.(".$type.")$/", $file)) {
                $filename = preg_replace("/(.+)\.(".$type.")$/", "$1.$2", $file);
                $results[] = $filename;
            }
       }
        closedir($handler);
        return $results;
    }
    
    public function getColors()
    {
        $colors = $this->getFiles(BASE_PATH . '/css/ui/' . THEME . '/colors', 'css');
        $result = array();
        // Loop through the files
        foreach ($colors as $color) {
            $fp = fopen( BASE_PATH . '/css/ui/' . THEME . '/colors/' . $color, 'r' );
            $file_data = fread( $fp, 8192 );
            fclose( $fp );
            
            if (preg_match("/\*([^*]|[\r\n]|(\*+([^*\/]|[\r\n])))*\*+/", $file_data, $matches)) {
                if (preg_match_all("/.+:.+?\n/", $matches[0], $fields)) {
                    $field_data = array();
                    foreach($fields as $field) {
                        foreach($field as $d) {
                            $d2 = explode(":", $d);
                            $field_data[trim($d2[0])] = trim($d2[1]);
                        }
                    }
                    $result[] = $field_data + array("url" => 'css/ui/' . THEME . '/colors/' . $color);
                }
            }
        }
        return $result;
    }
    
    function getDirectories( $path = '.' )
    {
        $directories = array();
        // Directories to ignore when listing output.	
        $ignore = array( '.', '..' );

        $dh = @opendir( $path );

        // Loop through the directory
        while( false !== ( $file = readdir( $dh ) ) ) {
            // Check that this file is not to be ignored
            if( !in_array( $file, $ignore ) && is_dir( "$path/$file" ) ) {
                $directories[] = $file;
            }
        }
        // Close the directory handle
        closedir( $dh );
        
        return $directories;
    }
    
    function getThemes()
    {
        $result = array();
        $basedir = BASE_PATH . '/css/ui/';
        $themefile = 'ui.css';
        $directories = $this->getDirectories($basedir);
        foreach($directories as $directory) {
            // check if the directory contains a valid theme file
            if (is_file($basedir . $directory . '/' . $themefile)) {
                $fp = fopen( $basedir . $directory . '/' . $themefile, 'r' );
                $file_data = fread( $fp, 8192 );
                fclose( $fp );
                
                if (preg_match("/\*([^*]|[\r\n]|(\*+([^*\/]|[\r\n])))*\*+/", $file_data, $matches)) {
                    if (preg_match_all("/.+:.+?\n/", $matches[0], $fields)) {
                        $field_data = array();
                        foreach($fields as $field) {
                            foreach($field as $d) {
                                $d2 = explode(":", $d);
                                $field_data[trim($d2[0])] = trim($d2[1]);
                            }
                        }
                        $result[] = $field_data + array("directory" => $directory, "url" => 'css/ui/' . $directory);
                    }
                }
            }
        }
        
        return $result;
    }
    
    function getCurrentThemeInfo() {
        $basedir = BASE_PATH . '/css/ui/';
        $themefile = 'ui.css';
        $fp = fopen( $basedir . THEME . '/' . $themefile, 'r' );
        $file_data = fread( $fp, 8192 );
        fclose( $fp );
        
        if (preg_match("/\*([^*]|[\r\n]|(\*+([^*\/]|[\r\n])))*\*+/", $file_data, $matches)) {
            if (preg_match_all("/.+:.+?\n/", $matches[0], $fields)) {
                $field_data = array();
                foreach($fields as $field) {
                    foreach($field as $d) {
                        $d2 = explode(":", $d);
                        $field_data[trim($d2[0])] = trim($d2[1]);
                    }
                }
                return $field_data + array("directory" => $directory, "url" => 'css/ui/' . $directory);
            }
        }
    }

}

