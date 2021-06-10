<?php

namespace LeiCodes\Lib;

use PDO;
use LeiCodes\Lib\Constants;
use LeiCodes\Lib\Api\ApiProvider;

abstract class AbstractController implements ControllerInterface
{
    protected $templateFile;
    protected $templateVars;
    protected $jsonError;
    protected $jsonResult = true;
    protected $httpOutput = null;
    protected $jsonOutput = null;
    protected $organizationID = false;
    protected $orderID = false;
    protected $formatter;
    protected $api;

    public function jsonResponse()
    {
        ob_clean();
        echo json_encode(
            ['response' => [
                    'result' => $this->jsonResult,
                    'error' => $this->jsonError
                ]
            ]
        );
        die;
    }

    public function httpResponse()
    {
        return [
            'templatefile' => $this->templateFile,
            'vars' => $this->templateVars
        ];
    }

    public function parseOrderDetails($data)
    {
        if(!empty($this->params['customfields']['lei_code_order_id'])){
            return $this->api->getLeiDetailsCheck($data);
        }
        return false;
    }

    public function parseOrderStatus()
    {
        if(!empty($this->params['customfields']['lei_code_order_id'])){
            $order = $this->api->getLeiStatus($this->params['customfields']['lei_code_order_id']);
            $dbModel = LeiCodeOrderModel::find($this->params['serviceid']);

            switch($order['status']) {
                case 'processing':
                    $status = strtoupper($order['status']);
                    if($dbModel->confirmed == 1){
                        $infotext = $this->lang["STATUS_{$status}_CONFIRMED"];
                    } else {
                        $infotext = $this->lang["STATUS_{$status}_NOTCONFIRMED"];
                    }
                    $info = 'step2';
                    break;
                case 'pending':
                    $dbModel->confirmed == 1 ? $info = 'step3' : $info = 'step2';
                    break;
                case 'need_action':
                case 'pre_issue';
                case 'user_confirmed';
                    $info = 'step3';
                    break;
                case 'new_order':
                    $info = 'none';
                    break;
                default:
                    $info = $order['status'];
            }

        } else {
            $info = 'none';
            $order = [];
        }

        if(empty($infotext && $info != 'none')){
            $status = strtoupper($order['status']);
            $infotext = $this->lang["STATUS_{$status}"];
        }

        return [
            'order' => $order,
            'infostatus' => $info,
            'infotext' => $infotext
        ];
    }

    public function checkRenew($tillDate){
        if(date('Y-m-d H:i:s', strtotime(time(). '+ 30 days')) >= $tillDate){
            $now = time();
            $tillDateStr = strtotime($tillDate);
            $datediff = $tillDateStr - $now;
            return round($datediff / (60 * 60 * 24));
        }
        return false;
    }

    public function checkExpiration($tillDate){
        if(date('Y-m-d H:i:s') > $tillDate){
            return true;
        }
        return false;
    }

    public function checkInvoiceStatus(){
        $invoiceItems = \WHMCS\Billing\Invoice\Item::where('userid', $this->params['userid'])
            ->where('type', 'Hosting')
            ->where('relid', $this->params['serviceid'])
            ->where('duedate', '<=', date('Y-m-d', strtotime('+ 30 days')))
            ->orderBy('id', 'desc')
            ->first();
        if(empty($invoiceItems->invoiceid)){
            return Constants::INVOICE_NOT_CREATED;
        }

        $invoice = \WHMCS\Billing\Invoice::find($invoiceItems->invoiceid);
        if($invoice->status == 'Paid'){
            return Constants::INVOICE_CREATED_PAID;
        }
        return Constants::INVOICE_CREATED_UNPAID;
    }
}
