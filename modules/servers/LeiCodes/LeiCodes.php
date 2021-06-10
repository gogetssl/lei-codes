<?php

use LeiCodes\Lib\Controller;
use LeiCodes\Lib\Api\ApiProvider;
use LeiCodes\Lib\LeiCodeOrderModel;

require_once 'autoloader.php';

if (!defined("WHMCS")) {
    die("This file cannot be accessed directly");
}

function LeiCodes_MetaData()
{
    return [
        'DisplayName' => 'LEI Codes',
        'APIVersion' => '1.1',
        'RequiresServer' => false,
    ];
}

function LeiCodes_ConfigOptions($params)
{
    return [
        "apiUsername" => [
            "FriendlyName" => "API Username",
            "Type" => "text",
        ],
        "apiPassword" => [
            "FriendlyName" => "API Password",
            "Type" => "text",
        ],
        "product" => [
            "FriendlyName" => "Product",
            "Type" => "dropdown",
            "Options" => [
                161 => "LEI Code",
                //162 => "LEI Code PRO",
                //165 => "LEI Code Renewal Transfer"
            ]
        ],
        "openCorporatesApiKey" => [
            "FriendlyName" => "Company Lookup API Key",
            "Type" => "text",
            "Description" => "Visit <a href='https://opencorporates.com/info/our-data/'>https://opencorporates.com/info/our-data/</a> to get new API key that is mandatory for companies lookup"
        ]
    ];
}

function LeiCodes_Renew($params)
{
    try {
        $orderModel = LeiCodeOrderModel::find($params['serviceid']);
        if($orderModel->renewal == 1)
        {
            ApiProvider::getInstance()->getApi()->renewOrder($params['customfields']['lei_code_order_id'], ['isLevel1DataSame' => 1]);
        }
    } catch (Exception $e) {
        return;
    }
}

function LeiCodes_CreateAccount($params)
{
   return 'success';
}

/*********** CLIENT AREA **********/

function LeiCodes_ClientAreaCustomButtonArray($params)
{
    try {
        return [
            "Step1" => "step1",
            "Step2" => "step2",
            "Step3" => "step3"
        ];
    } catch (Exception $e) {
        return;
    }
}

function LeiCodes_ClientArea($params)
{
    add_hook('ClientAreaPrimarySidebar', 1, function (WHMCS\View\Menu\Item $primarySidebar) use ($params) {
        $panel = $primarySidebar->getChild('Service Details Overview');
        if (is_a($panel, 'WHMCS\View\Menu\Item')) {
            $panel = $panel->getChild('Information');
            if (is_a($panel, 'WHMCS\View\Menu\Item')) {
                $panel->setUri("clientarea.php?action=productdetails&id={$params['serviceid']}");
                $panel->setAttributes([]);
            }
        }
    });

    try {
        if (!empty($_REQUEST['a'])) {
            $method = $_REQUEST['a'];
            return ((new Controller($params))->$method());
        }
       
        if ($_REQUEST['action'] == 'productdetails' && !isset($_REQUEST['modop'])) {
            return ((new Controller($params))->overview());
        }
    } catch (Exception $e) {
       
    }
}


function LeiCodes_step1($params)
{
    try {
        return ((new Controller($params))->firstStep());
    } catch (Exception $e) {
    
    }
}

function LeiCodes_step2($params)
{
    try {
        return ((new Controller($params))->secondStep());
    } catch (Exception $e) {
    
    }
}

function LeiCodes_step3($params)
{
    try {
        return ((new Controller($params))->thirdStep());
    } catch (Exception $e) {
    
    }
}
