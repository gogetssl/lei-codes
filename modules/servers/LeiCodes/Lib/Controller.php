<?php

namespace LeiCodes\Lib;

use Exception;
use LeiCodes\Lib\Lang;
use LeiCodes\Lib\Helper;
use LeiCodes\Lib\Api\LeiApi;
use LeiCodes\Lib\Api\CompanyApi;
use LeiCodes\Lib\Api\ApiProvider;
use LeiCodes\Lib\LeiCodeOrderModel;
use LeiCodes\Lib\AbstractController;

class Controller extends AbstractController
{
    protected $params;
    protected $lang;

    public function __construct($params)
    {
        $this->params = $params;
        $this->setLang()
                ->setApi()
                ->getDetails();
    }

    /**
     * lang setter
     *
     * @return this
     */
    public function setLang()
    {
        $this->lang = Lang::getLang();
        return $this;
    }

    /**
     * lang setter
     *
     * @return this
     */
    public function setApi()
    {
        $this->api = ApiProvider::getInstance()->getApi();
        return $this;
    }

    /**
     * call controller method from $_REQUEST['a']
     */
    public function __call($name, $vars)
    {
        if (!method_exists($this, $name)) {
            return false;
        }
        return call_user_func_array([$this, $name], $vars);
    }

    /**
     * First Step of order configuration
     *
     * GET step1
     * 
     * @return array
     */
    private function firstStep()
    {
        if(!empty($this->params['customfields']['lei_code_order_id']))
        {
            header('Location: clientarea.php?action=productdetails&id='.$this->params['serviceid'].'&modop=custom&a=step2');
            exit();
        }
        $this->templateFile = 'step1';
        $this->templateVars = [
            'jurisdictions' => Helper::getJurisdictionCountries($this->api->getLeiJurisdictions()['jurisdictions']),
            'MGLANG' => $this->lang,
            'countriesCodes' => Helper::getCountriesCodes()
        ];
        return $this->httpResponse();
    }

    /**
     * Second Step of order configuration
     *
     * GET step2
     * 
     * @return array
     */
    private function secondStep()
    {
        try{
            if(empty($this->params['customfields']['lei_code_order_id']))
            {
                header('Location: clientarea.php?action=productdetails&id='.$this->params['serviceid']);
                exit();
            }

            $this->templateFile = 'step2';

            $data = $this->parseOrderStatus();

            $data['order']->orderID = $this->params['customfields']['lei_code_order_id'];
            $jurisdictionCode = LeiCodeOrderModel::where('hosting_id', $this->params['serviceid'])->first()->entity_jurisdiction_code;
        
            $jurisdictions = $this->api->getLeiJurisdictions()['jurisdictions'];
            foreach($jurisdictions as $jurisdiction)
            {
                if($jurisdiction['code'] == $jurisdictionCode){
                    $waitingInfo = $this->lang[$jurisdiction['group']].$jurisdiction['name'];
                }
            }
            if($data['infostatus'] == 'need_action'){
                header('Location: clientarea.php?action=productdetails&id='.$this->params['serviceid']).'&modop=custom&a=step3';
                exit();
            }
            $this->templateVars = [
                'order' => $data['order'],
                'infostatus' => $data['infostatus'],
                'orderData' => LeiCodeOrderModel::find($this->params['serviceid']),
                'waitingInfo' => $waitingInfo,
                'years' => $this->lang["{$this->params['model']->billingcycle}Cycle"],
                'MGLANG' => $this->lang,
                'countriesCodes' => Helper::getCountriesCodes()
            ];
            return $this->httpResponse();
        } catch (Exception $e)
        {
            $this->templateVars = [
                'error' => $e->getMessage(),
            ];
            return $this->httpResponse();
        }
    }

    /**
     * Third Step of order configuration
     *
     * GET step3
     * 
     * @return array
     */
    private function thirdStep()
    {
        if(empty($this->params['customfields']['lei_code_order_id']))
        {
            header('Location: clientarea.php?action=productdetails&id='.$this->params['serviceid']);
            exit();
        }
        $data = $this->parseOrderStatus();

        $data['order']->orderID = $this->params['customfields']['lei_code_order_id'];
        $jurisdictionCode = LeiCodeOrderModel::where('hosting_id', $this->params['serviceid'])->first()->entity_jurisdiction_code;
    
        $jurisdictions = $this->api->getLeiJurisdictions()['jurisdictions'];
        foreach($jurisdictions as $jurisdiction)
        {
            if($jurisdiction['code'] == $jurisdictionCode){
                $waitingInfo = $this->lang[$jurisdiction['group']].$jurisdiction['name'];
            }
        }
        $dbLeiModel = LeiCodeOrderModel::find($this->params['serviceid']);
        if($data['order']['status'] != 'need_action'){
            if($dbLeiModel->confirmed != 1){
                header('Location: clientarea.php?action=productdetails&id='.$this->params['serviceid'].'&modop=custom&a=step2');
                exit();
            }
        }
        $this->templateFile = 'step3';
        $this->templateVars = [
            'order' => $data['order'],
            'infostatus' => $data['infostatus'],
            'orderData' => $dbLeiModel,
            'waitingInfo' => $waitingInfo,
            'years' => $this->lang["{$this->params['model']->billingcycle}Cycle"],
            'MGLANG' => $this->lang,
            'countriesCodes' => Helper::getCountriesCodes()
        ];
        return $this->httpResponse();
    }

    /**
     * Displaying lei code details
     *
     * GET
     * 
     * @return array
     */
    private function overview()
    {
        try {
            $this->templateFile = 'overview';
            $data = $this->parseOrderStatus();
            if($data['order']['status'] == 'active')
            {
                $gogetApiEntity = $this->parseOrderDetails($data['order']['lei_number'])['result'][0];
            }
            
            $renew = $this->checkRenew($data['order']['valid_till']);
            if($renew)
            {
                $expiration = $this->checkExpiration($data['order']['valid_till']);
                if($expiration){
                    $invoicePaid = $this->checkInvoiceStatus();
                } else {
                    $this->lang['renewInfoContent'] = str_replace(':days', $renew, $this->lang['renewInfoContent']);
                    $this->lang['renewInfoContent'] = str_replace(':validTill', $data['order']['valid_till'], $this->lang['renewInfoContent']);
                }
            }
            $this->templateVars = [
                'order' => $data['order'],
                'dbOrder' => LeiCodeOrderModel::find($this->params['serviceid']),
                'infostatus' => $data['infostatus'],
                'infotext' => $data['infotext'],
                'MGLANG' => $this->lang,
                'orderDetails' => $gogetApiEntity,
                'years' => $this->lang["{$this->params['model']->billingcycle}Cycle"],
                'countriesCodes' => Helper::getCountriesCodes(),
                'renew' => $renew,
                'expiration' => $expiration,
                'invoicePaid' => $invoicePaid
            ];
            return $this->httpResponse();
        } catch (Exception $e) {
            $this->templateFile = 'overview-error';
            $this->templateVars = [
                'error' => $e->getMessage(),
            ];
        } finally {
            return $this->httpResponse();
        }
    }

    private function findEntity()
    {
        $params = Helper::moduleParams($_REQUEST['id']);
        try {
            $this->jsonResult = CompanyApi::call($_POST['jurisdiction'], $_POST['name'], $params['configoption4']);
        } catch (Exception $e) {
            $this->jsonError = $e->getMessage();
            $this->jsonResult = false;
        } finally {
            return $this->jsonResponse();
        }
    }

    private function findEntityByNumber()
    {
        $params = Helper::moduleParams($_REQUEST['id']);
        try {
            $this->jsonResult = CompanyApi::callByNumber($_POST['jurisdiction'], $_POST['entityid'], $params['configoption4']);
        } catch (Exception $e) {
            $this->jsonError = $e->getMessage();
            $this->jsonResult = false;
        } finally {
            return $this->jsonResponse();
        }
    }

    private function findLei()
    {
        try {
            $data = LeiApi::call($_POST['company']);
            if($data['lei']){
                $gogetApiEntity = ApiProvider::getInstance()->getApi()->getLeiDetailsCheck($data['lei']);
                $this->jsonResult = [
                    'result' => $gogetApiEntity->result[0],
                    'code' => $data['code']
                ];
            } else {
                $this->jsonResult = [
                    'code' => $data['code']
                ];
            }
        } catch (Exception $e) {
            $this->jsonError = $e->getMessage();
            $this->jsonResult = false;
        } finally {
            return $this->jsonResponse();
        }
    }


    private function checkOrderStatus()
    {
        try {
            $order = $this->api->getLeiStatus($this->params['customfields']['lei_code_order_id']);
            switch ($order['status']) {
                case 'incomplete':
                case 'pending':
                case 'processing':
                case 'unpaid':
                    $info = 0;
                    break;
                case 'need_action':
                    $info = 1;
                    break;
                default:
                    $info = 0;
            }
            $this->jsonResult = $info;
        } catch (Exception $e) {
            $this->jsonError = $e->getMessage();
            $this->jsonResult = 0;
        } finally {
            return $this->jsonResponse();
        }
    }

    private function confirmOrder()
    {
        try {
            $confirm = $_POST['confirm'];
            ApiProvider::getInstance()->getApi()->confirmLeiDataQuality($this->params['customfields']['lei_code_order_id'], ['confirm' => $confirm]);
            LeiCodeOrderModel::updateOrCreate(['hosting_id' => $this->params['serviceid']], ['confirmed' => 1]);
            $this->jsonResult = [
                'confirm' => $confirm,
                'success' => 1
            ];
        } catch (Exception $e) {
            $this->jsonError = $e->getMessage();
            $this->jsonResult = false;
        } finally {
            return $this->jsonResponse();
        }
    }

    private function confirmRenewal()
    {
        try {
            $confirm = $_POST['confirm'];
            $invoiceStatus = $this->checkInvoiceStatus();
            switch($invoiceStatus)
            {
                case Constants::INVOICE_CREATED_UNPAID:
                case Constants::INVOICE_NOT_CREATED:
                    $confirm = 0;
                break;
                case Constants::INVOICE_CREATED_PAID:
                    ApiProvider::getInstance()->getApi()->renewOrder($this->params['customfields']['lei_code_order_id'], ['isLevel1DataSame' => 1]);
                    $confirm = 1;
                break;
            }
            
            if($invoiceStatus != Constants::INVOICE_CREATED_PAID){
                LeiCodeOrderModel::updateOrCreate(['hosting_id' => $this->params['serviceid']], ['renewal' => 1]);
            }
            
            $this->jsonResult = [
                'confirm' => $confirm,
                'success' => 1
            ];
        } catch (Exception $e) {
            $this->jsonError = $e->getMessage();
            $this->jsonResult = false;
        } finally {
            return $this->jsonResponse();
        }
    }

    private function createOrder()
    {

        try {
            $entityName = $_POST['legalName'];
            $entityState = $_POST['legalState'];
            $entityPostalCode = $_POST['legalPostal'];
            $entityCountry = $_POST['legalCountry'];
            $entityCity = $_POST['legalCity'];
            $entityStreet = $_POST['legalfirstAddressLine'];
            $entityID = $_POST['legalID'];
            if($_POST['legalDropdown'] == 'false')
            {
                $entityID = $_POST['registrationAuthorityEntityId'];
                $companyData = CompanyApi::callByNumber($_POST['legalJurisdiction'], $entityID, $this->params['configoption4']);

                $entityName = $companyData->name;
                $entityCountry = $companyData->registered_address->country ?: false;
                $entityCity = $companyData->registered_address->locality ?: false;
                $entityState = $companyData->registered_address->region ?: false;
                $entityPostalCode = $companyData->registered_address->postal_code ?: false;
                $entityStreet = $entityPostalCode = $companyData->registered_address->street_address ?: false;
                $entityDate = $companyData->incorporation_date;

                if(empty($entityCountry) || empty($entityCity) || empty($entityPostalCode) || empty($entityStreet)){
                    throw new Exception($this->lang['noFullDataExists']);
                }
            }

            LeiCodeOrderModel::updateOrCreate(['hosting_id' => $this->params['serviceid']], [
                'sa_firstname' => $_POST['firstName'],
                'sa_lastname' => $_POST['lastName'],
                'entity_jurisdiction_code' => $_POST['legalJurisdiction'],
                'entity_name' => $entityName ,
                'entity_id' => $entityID,
                'entity_state' => $entityState,
                'entity_postal_code' => $entityPostalCode,
                'entity_street' => $entityStreet,
                'entity_date' => $entityDate,
                'entity_country' => explode('-', $_POST['legalJurisdiction'])[0],
                'entity_city' => $entityCity,
                'transfer' => $_POST['transfer'],
                'isLevel2DataAvailable' => $_POST['isLevel2DataAvailable'],
                'isLevel2DataConsolidate' => $_POST['isLevel2DataAvailable'],
                'isLevel2DataUltimate' => $_POST['isLevel2DataAvailable'],
                'hq_country' => $_POST['hqCountry'],
                'hq_state' => $_POST['hqState'],
                'hq_street' => $_POST['firstName'],
                'hq_city' => $_POST['hqCity'],
                'hq_postal' => $_POST['hqPostal'],
                'created_at' => date('Y-m-d H:i:s')
            ]);
            
            switch($this->params['model']->billingcycle){
                case 'Annually':
                    $years = 1;
                break;
                case 'Biennially':
                    $years = 2;
                break;
                case 'Triennially':
                    $years = 3;
                break;
                default:
                    throw new Exception($this->lang['incorrectPeriod']);
            }

            $postData = [
                "productId" => $this->params['configoption3'],
                "legalName" => $entityName,
                "registrationAuthorityEntityId" => $entityID,
                "legalJurisdiction" => $_POST['legalJurisdiction'],
                "firstName" => $_POST['firstName'],
                "lastName" => $_POST['lastName'],
                "isLevel2DataAvailable" => (int)$_POST['isLevel2DataAvailable'],
                "legalPostal" => $entityPostalCode,
                "legalfirstAddressLine" => $entityStreet,
                "legalCountry" => $entityCountry,
                "legalCity" => $entityCity,
                "multiYearSupport" => $years,
                "transfer" => $_POST['transfer'],
            ];

            if(!empty($_POST['isLevel2DataAvailable'])){
                $postData['isLevel2DataConsolidate'] = $_POST['isLevel2DataConsolidate'];
                $postData['isLevel2DataUltimate'] = $_POST['isLevel2DataUltimate'];
            }
            
            if(!empty($entityState)){
                $postData['legalState'] = $entityState;
            }

            if(!empty($entityDate)){
                $postData['incorporationDate'] = $entityDate;
            }

            if($_POST['headquarters'] == 1)
            {
                $postData['hqCity'] = $_POST['hqCity'];
                $postData['hqState'] = $_POST['hqState'];
                $postData['hqCountry'] = $_POST['hqCountry'];
                $postData['hqfirstAddressLine'] = $_POST['hqfirstAddressLine'];
                $postData['hqPostal'] = $_POST['hqPostal'];
            }

            $result = ApiProvider::getInstance()->getApi()->createOrder($postData);
            $customFieldId = CustomFieldRepository::getCustomField(CustomFieldRepository::LEICODE_ORDER_ID, $this->params['packageid'], 'product')->id;
            CustomFieldRepository::saveCustomFieldValue($customFieldId, $this->params['serviceid'], $result['order_id']);
            LeiCodeOrderModel::updateOrCreate(['hosting_id' => $this->params['serviceid']], ['order_id' => $result['order_id']]);

            $this->jsonResult = true;
        } catch (Exception $e) {
            $this->jsonError = $e->getMessage();
            $this->jsonResult = false;
        } finally {
            return $this->jsonResponse();
        }
    }
}
