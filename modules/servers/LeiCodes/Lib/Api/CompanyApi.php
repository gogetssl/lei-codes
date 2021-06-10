<?php

namespace LeiCodes\Lib\Api;

class CompanyApi
{
    const URL = 'https://api.opencorporates.com/v0.4/companies/search?';

    public static function call($jurisdiction = false, $name = false, $apiKey)
    {
       $params = http_build_query([
           'q' => $name,
           'jurisdiction_code' => str_replace('-', '_', strtolower($jurisdiction)),
           'inactive' => false,
           'api_token' => $apiKey
       ]);
       $response = json_decode(file_get_contents(self::URL.$params));
       logModuleCall('LeiCodes - COMPANY API', 'GET Companies', $params, $response);
       return $response;
    }

    public static function callByNumber($jurisdiction = false, $id = false, $apiKey)
    {
        $params = http_build_query([
            'company_number' => $id,
            'jurisdiction_code' => str_replace('-', '_', strtolower($jurisdiction)),
            'inactive' => false,
            'api_token' => $apiKey
        ]);
        $response = json_decode(file_get_contents(self::URL.$params))->results->companies[0]->company;
        logModuleCall('LeiCodes - COMPANY API', 'GET Companies (by ID)', $params, $response);
        return $response;
    }
}
