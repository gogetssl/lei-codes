<?php

require_once 'autoloader.php';

use LeiCodes\Lib\Helper;
use LeiCodes\Lib\Api\ApiProvider;
use LeiCodes\Lib\CustomFieldModel;
use LeiCodes\Lib\LeiCodeOrderModel;
use LeiCodes\Lib\CustomFieldRepository;

add_hook('ClientAreaPrimarySidebar', 1, function(\WHMCS\View\Menu\Item $primarySidebar) {

    if(isset($_REQUEST['id']) && $_REQUEST['action'] == 'productdetails'){
        $params = Helper::moduleParams($_REQUEST['id']);
        if($params['moduletype'] != 'LeiCodes' || $params['model']->domainstatus != 'Active' || strpos($_REQUEST['a'], 'step') === false)
        {
            return;
        }
    } else {
        return;
    }
    $lang = LeiCodes\Lib\Lang::getLang();
    $stepnumber = $stepNumber = substr($_REQUEST['a'], 4);
    $step = $primarySidebar->addChild('Step');
    $step->setLabel(
        sprintf(\Lang::trans("step"), $stepNumber) .
        "<span class=\"pull-right\">" . "<i class=\"far fa-dot-circle\">&nbsp;</i>" .
        "<i class=\"far fa-" . (2 <= $stepnumber ? "dot-" : "") . "circle\">&nbsp;</i>" .
        "<i class=\"far fa-" . (3 <= $stepnumber ? "dot-" : "") . "circle\">&nbsp;</i>" .
        "</span>"
    );
    $params = Helper::moduleParams($_REQUEST['id']);
    $order = LeiCodeOrderModel::where('hosting_id', $_REQUEST['id'])->first();
    try{
        if(empty($order->order_id)){
            $status = $lang['uninitialized'];
        } else {
            $api = ApiProvider::getInstance()->getApi()->getLeiStatus($params['customfields']['lei_code_order_id']);
            $status = str_replace('_', ' ', ucfirst($api['status']));
        }
    } catch (Exception $e)
    {

    }

    
    $price = formatCurrency($params['model']->firstpaymentamount)->toFull();
    $step->setAttributes(['class' => 'panel-info']);
    $step->setIcon('fa-certificate');
    $step->addChild(
        "product",[
            "name" => "product",
            "label" => "<strong>{$lang['productType']}</strong><br>{$params['model']->product->name}", 
            "order" => 1,
    ]);
    $step->addChild(
        "orderdate",[
            "name" => "orderdate",
            "label" => "<strong>{$lang['orderDate']}</strong><br>{$params['model']->regdate}", 
            "order" => 2,
    ]);
    $step->addChild(
        "price",[
            "name" => "price",
            "label" => "<strong>{$lang['orderPrice']}</strong><br>{$price}", 
            "order" => 3,
    ]);
    $step->addChild(
        "status",[
            "name" => "status",
            "label" => "<strong>{$lang['configurationStatus']}</strong><br>{$status}",
            "order" => 4,
    ]);
});


add_hook('ClientAreaHeadOutput', 1, function($vars) {

    if(isset($_REQUEST['id']) && $_REQUEST['action'] == 'productdetails'){
        $params = Helper::moduleParams($_REQUEST['id']);
        if($params['moduletype'] != 'LeiCodes' || $params['model']->domainstatus != 'Active')
        {
            return;
        }
    } else {
        return;
    }

    return <<<SCRIPT
    <script>
        $(document).ready(function(){
            $('div[menuitemname="Step"]').find('.fa-chevron-up').remove();
            $('a[menuitemname="Custom Module Button Step1"]').remove();
            $('a[menuitemname="Custom Module Button Step2"]').remove();
            $('a[menuitemname="Custom Module Button Step3"]').remove();
        })
    </script>
SCRIPT;
});

add_hook('AdminProductConfigFieldsSave', 1, function ($vars) {
    
    if($_REQUEST['servertype'] != 'LeiCodes')
    {
        return;
    }

    if (!\WHMCS\Database\Capsule::schema()->hasTable('LeiCodes_Orders')) {
        \WHMCS\Database\Capsule::schema()->create('LeiCodes_Orders', function ($table) {
            $table->integer('hosting_id');
            $table->integer('order_id')->nullable();
            $table->tinyInteger('confirmed')->nullable();
            $table->tinyInteger('renewal')->nullable();
            $table->string('sa_firstname')->nullable();
            $table->string('sa_lastname')->nullable();
            $table->string('entity_jurisdiction_code')->nullable();
            $table->string('entity_name')->nullable();
            $table->string('entity_id')->nullable();
            $table->string('entity_state')->nullable();
            $table->string('entity_city')->nullable();
            $table->string('entity_postal_code')->nullable();
            $table->string('entity_street')->nullable();
            $table->string('entity_country')->nullable();
            $table->date('entity_date')->nullable();
            $table->tinyInteger('transfer')->nullable();
            $table->tinyInteger('isLevel2DataAvailable')->nullable();
            $table->tinyInteger('isLevel2DataConsolidate')->nullable();
            $table->tinyInteger('isLevel2DataUltimate')->nullable();
            $table->string('hq_country')->nullable();
            $table->string('hq_state')->nullable();
            $table->string('hq_street')->nullable();
            $table->string('hq_city')->nullable();
            $table->string('hq_postal')->nullable();
            $table->datetime('created_at')->nullable();
            $table->primary('hosting_id')->nullable();
        });
    }

    if(empty(\WHMCS\Database\Capsule::table('tblemailtemplates')->where('name', 'Lei Code Expiration')->first()->id)){
        \WHMCS\Database\Capsule::table('tblemailtemplates')
            ->insert(
                ['name' => 'Lei Code Expiration', 'subject' => 'Lei Code Will Expire In Next 30 days', 'type' => 'product', 'custom' => 1, 'message' =>
                '<p>Dear {$client_name},</p><p>Your LEI Code for entity name {$entity_name} will expire in next 30 days.</p>
                <p>It is valid until {$valid_till}, but you can confirm renewal now, it will be renewed after next recurring invoice payment.</p><p>{$signature}</p>'
            ]);
    }


    $orderField = false;

    if(!isset($_REQUEST['packageconfigoption'])){
        return;
    }

    if(isset($_REQUEST['customfieldname'])){
        foreach($_REQUEST['customfieldname'] as $key => $customField){
            if (strpos($customField, CustomFieldRepository::LEICODE_ORDER_ID.'|') !== false) {
                $orderField = true;
            }
        }
    }
    
    if(!$orderField){
        CustomFieldModel::create([
            'relid' => $vars['pid'], 'type' => 'product', 'fieldname' => CustomFieldRepository::LEICODE_ORDER_ID.'|LeiCodes Order ID', 
            'fieldtype' => 'text', 'description' => 'Lei Code Order ID', 'adminonly' => 'on'
        ]);
    }
});

add_hook('DailyCronJob', 1, function($vars) {

    $leiCodesOrders = LeiCodeOrderModel::all();
    foreach($leiCodesOrders as $order)
    {
        if($order->service->domainstatus != 'Active'){
            continue;
        }
        $params = Helper::moduleParams($order->hosting_id);
        if(!isset($params['customfields']['lei_code_order_id']) || empty($params['customfields']['lei_code_order_id']))
        {
            continue;
        }

        $orderDetails = ApiProvider::getInstance()
            ->setID($order->hosting_id)
            ->getApi()
            ->getLeiStatus($params['customfields']['lei_code_order_id']);
    
        if(date('Y-m-d', strtotime($orderDetails['valid_till']. ' - 30 days')) == date('Y-m-d')){
            sendMessage('Lei Code Expiration', $order->hosting_id. [
                'valid_till' => $orderDetails['valid_till'],
                'valid_from' => $orderDetails['valid_till'],
                'lei_code' => $orderDetails['lei_code'],
                'sa_firstname' => $order->sa_firstname,
                'sa_lastname' => $order->sa_lastname,
                'entity_name' => $order->entity_name,
            ]);
        }
    }
});

