<?php

namespace LeiCodes\Lib\Api;

class SSLCenterApi {

    protected $apiUrl = 'https://my.gogetssl.com/api';
    protected $key;
    protected $lastStatus;
    protected $lastResponse;
    protected $lastRequest;
    protected $apiExceptions = true;
    protected $exceptionType;

    public function __construct($key = null, $apiUrl = null) {
        $this->key = isset($key) ? $key : null;
        $this->setSSLCenterApiException();
    }
    
    public function setSSLCenterException() {
        $this->exceptionType = 'SSLCenterException';
    }
    
    public function setSSLCenterApiException() {
        $this->exceptionType = 'SSLCenterApiException';
    }
    
    public function setNoneException() {
        $this->exceptionType = 'none';
    }

    public function turnOnApiExceptions() {
        $this->apiExceptions = true;
    }
    
    public function turnOffApiExceptions() {
        $this->apiExceptions = false;
    }

    public function auth($user, $pass) {
        $response = $this->call('/auth/', [], array(
            'user' => $user,
            'pass' => $pass
        ));
        
        if (!empty($response ['key'])) {
            $this->key = $response ['key'];
            return $response;
        }
        
        return $response;
    }

    public function addSslSan($orderId, $count) {
        if ($count) {
            $postData ['order_id'] = $orderId;
            $postData ['count'] = $count;
        }

        return $this->call('/orders/add_ssl_san_order/', $getData, $postData);
    }

    public function cancelSSLOrder($orderId, $reason) {
        $postData ['order_id'] = $orderId;
        $postData ['reason'] = $reason;

        return $this->call('/orders/cancel_ssl_order/', $getData, $postData);
    }

    public function changeDcv($orderId, $data) {
        return $this->call('/orders/ssl/change_dcv/' . (int) $orderId, $getData, $data);
    }
    public function changeValidationMethod($orderId, $data) {
        return $this->call('/orders/ssl/change_validation_method/' . (int) $orderId, $getData, $data);
    }
    public function revalidate($orderId, $data) {
        return $this->call('/orders/ssl/revalidate/' . (int) $orderId, $getData, $data);
    }
    public function changeValidationEmail($orderId, $data) {
        return $this->call('/orders/ssl/change_validation_email/' . (int) $orderId, $getData, $data);
    }

    public function setKey($key) {
        if ($key) {
            $this->key = $key;
        }
    }

    public function setUrl($url) {
        $this->apiUrl = $url;
    }

    public function decodeCSR($csr, $brand = 1, $wildcard = 0) {
        if ($csr) {
            $postData ['csr'] = $csr;
            $postData ['brand'] = $brand;
            $postData ['wildcard'] = $wildcard;
        }

        return $this->call('/tools/csr/decode/', $getData, $postData);
    }

    public function getWebServers($type) {
        return $this->call('/tools/webservers/' . (int) $type, $getData);
    }

    public function getDomainAlternative($csr = null) {
        $postData['csr'] = $csr;

        return $this->call('/tools/domain/alternative/', $getData, $postData);
    }

    public function getDomainEmails($domain) {
        if ($domain) {
            $postData ['domain'] = $domain;
        }

        return $this->call('/tools/domain/emails/', $getData, $postData);
    }

    public function getDomainEmailsForGeotrust($domain) {
        if ($domain) {
            $postData ['domain'] = $domain;
        }

        return $this->call('/tools/domain/emails/geotrust', $getData, $postData);
    }

    public function getAllProductPrices() {
        return $this->call('/products/all_prices/', $getData);
    }

    public function getAllProducts() {
        return $this->call('/products/', $getData);
    }

    public function getProduct($productId) {
        return $this->call('/products/ssl/' . $productId, $getData);
    }

    public function getProducts() {
        return $this->call('/products/ssl/', $getData);
    }

    public function getProductDetails($productId) {
        return $this->call('/products/details/' . $productId, $getData);
    }

    public function getProductPrice($productId) {
        return $this->call('/products/price/' . $productId, $getData);
    }

    public function getUserAgreement($productId) {
        return $this->call('/products/agreement/' . $productId, $getData);
    }

    /**
     * LEI 
     */

    public function createOrder($data) {
        return $this->call('/orders/lei/create/', $getData, $data);
    }

    public function confirmLeiDataQuality($orderid, $data) {
        return $this->call('/lei/confirm/'.$orderid, $getData, $data);
    }

    public function getLeiJurisdictions() {
        return $this->call('/lei/jurisdictions/', $getData);
    }

    public function getLeiStatus($orderid) {
        return $this->call('/lei/status/'.$orderid, $getData);
    }

    public function getLeiDetails($orderid) {
        return $this->call('/lei/lookup/'.$orderid, $getData);
    }

    public function getLeiDetailsCheck($name) {
        return $this->call('/lei/lookup?query='.$name, $getData);
    }

    public function renewOrder($orderid, $data) {
        return $this->call('/orders/lei/renew/'.$orderid, $getData, $data);
    }
    /**
     * LEI 
     */

    public function getAccountBalance() {
        return $this->call('/account/balance/', $getData);
    }

    public function getAccountDetails() {
        return $this->call('/account/', $getData);
    }

    public function getTotalOrders() {
        return $this->call('/account/total_orders/', $getData);
    }

    public function getAllInvoices() {
        return $this->call('/account/invoices/', $getData);
    }

    public function getUnpaidInvoices() {
        return $this->call('/account/invoices/unpaid/', $getData);
    }

    public function getTotalTransactions() {
        return $this->call('/account/total_transactions/', $getData);
    }

    public function addSSLOrder1($data) {
        return $this->call('/orders/add_ssl_order1/', $getData, $data);
    }

    public function addSSLOrder($data) {
        return $this->call('/orders/add_ssl_order/', $getData, $data);
    }

    public function addSSLRenewOrder($data) {
        return $this->call('/orders/add_ssl_renew_order/', $getData, $data);
    }

    public function reIssueOrder($orderId, $data) {
        return $this->call('/orders/ssl/reissue/' . (int) $orderId, $getData, $data);
    }

    public function activateSSLOrder($orderId) {
        return $this->call('/orders/ssl/activate/' . (int) $orderId, $getData);
    }

    public function addSandboxAccount($data) {
        return $this->call('/accounts/sandbox/add/', $getData, $data);
    }

    public function getOrderStatus($orderId) {
        return $this->call('/orders/status/' . (int) $orderId, $getData);
    }

    public function comodoClaimFreeEV($orderId, $data) {
        return $this->call('/orders/ssl/comodo_claim_free_ev/' . (int) $orderId, $getData, $data);
    }

    public function getOrderInvoice($orderId) {
        return $this->call('/orders/invoice/' . (int) $orderId, $getData);
    }

    public function getUnpaidOrders() {
        return $this->call('/orders/list/unpaid/', $getData);
    }

    public function resendEmail($orderId) {
        return $this->call('/orders/ssl/resend_validation_email/' . (int) $orderId, $getData);
    }

    public function resendValidationEmail($orderId) {
        return $this->call('/orders/ssl/resend_validation_email/' . (int) $orderId, $getData);
    }

    public function getCSR($data) {
        return $this->call('/tools/csr/get/', $getData, $data);
    }

    public function generateCSR($data) {
        return $this->call('/tools/csr/generate/', $getData, $data);
    }
    
    protected function call($uri, $getData = [], $postData = [], $forcePost = false, $isFile = false) {
        
        $this->lastRequest = [
            'uri' => $uri,
            'post' => $postData,
        ];

        if($uri !== '/auth/') {
            $getData['auth_key'] = $this->key;
        }
        
        if($uri !== '/auth/' AND !$this->key) {
            throw new SSLCenterException('Authorization key is required');
        }
        $url = $this->apiUrl . $uri;
        if (!empty($getData)) {
            foreach ($getData as $key => $value) {
                $url .= (strpos($url, '?') !== false ? '&' : '?') . urlencode($key) . '=' . rawurlencode($value);
            }
        }

        $post = !empty($postData) || $forcePost ? true : false;
        $c = curl_init($url);
        if ($post) {
            curl_setopt($c, CURLOPT_POST, true);
        }

        $queryData = '';
        if (!empty($postData)) {
            $queryData = $isFile ? $postData : http_build_query($postData);
            curl_setopt($c, CURLOPT_POSTFIELDS, $queryData);
        }

        curl_setopt($c, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($c, CURLOPT_SSL_VERIFYPEER, false);

        $result = curl_exec($c);

        
        logModuleCall(
            'SSLCENTERWHMCS',
            $uri,
            $this->lastRequest,
            $result
        );

        if ($result === false) {
            throw new SSLCenterException(curl_error($c));
        }
        
        $status = curl_getinfo($c, CURLINFO_HTTP_CODE);
        curl_close($c);
        $this->lastStatus = $status;
        $this->lastResponse = json_decode($result, true);
        
        if(is_null($this->lastResponse)) {
            throw new SSLCenterApiException('Invalid Response from API');
        }
       
        if($this->lastResponse['error'] === true AND $this->apiExceptions AND $this->exceptionType === 'SSLCenterException') {
            throw new SSLCenterException($this->lastResponse['description']);
        }
        
        if($this->lastResponse['error'] === true AND $this->apiExceptions AND $this->exceptionType === 'SSLCenterApiException') {
            throw new SSLCenterApiException($this->lastResponse['description']);
        }
        
        return $this->lastResponse;
    }

    public function getLastStatus() {
        return $this->lastStatus;
    }

    public function getLastResponse() {
        return $this->lastResponse;
    }
    
  public function getLastRequest() {
        return $this->lastRequest;
    }
}