<?php

namespace LeiCodes\Lib\Api;

use LeiCodes\Lib\Helper;
use LeiCodes\Lib\Api\SSLCenterApi;
use LeiCodes\Lib\Api\SSLCenterException;

class ApiProvider {

    private static $instance;
    private $api;
    protected $id;

    public static function getInstance() {
        if (self::$instance === null) {
            self::$instance = new ApiProvider();
        }
        return self::$instance;
    }

    public function setID($id)
    {
       $this->id = $id;
       return $this;
    }

    public function getApi($exception = true) {
        if ($this->api === null) {
            $this->initApi();
        }
        
        if($exception) {
            $this->api->setSSLCenterApiException(); 
        } else {
            $this->api->setNoneException();
        }
        
        return $this->api;
    }

    private function initApi() {
        $params = $this->getCredentials();
        $this->api = new SSLCenterApi();
        $this->api->auth($params['configoption1'], $params['configoption2']);
    }
    
    private function getCredentials() {
        if(empty($this->id)){
            $params = Helper::moduleParams($_REQUEST['id']);
        } else {
            $params = Helper::moduleParams($this->id);
        }
        $apiUser = $params['configoption1'];
        $apiPassword = $params['configoption2'];
        if (empty($apiUser) || empty($apiPassword)) {
            throw new SSLCenterException('api_configuration_empty');
        }
        return $params;
    }
}
