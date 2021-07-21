<?php

namespace LeiCodes\Lib;

class Helper
{
    public static function moduleParams($id)
    {
        if(!function_exists("ModuleBuildParams"))
        {
            require_once ROOTDIR.'/includes/modulefunctions.php';
        }
        return ModuleBuildParams($id);
    }

    public static function getCountriesCodes()
    {
        $str = file_get_contents(ROOTDIR.DS."resources" . DS. 'country' . DS. 'dist.countries.json');
        $countries = json_decode($str, TRUE);
        $countriescodes = [];
        foreach($countries as $code => $country){
            $countriescodes[$country['name']] = $code;
        }
        return $countriescodes;
    }

    public static function getJurisdictionCountries($codes)
    {
        $str = file_get_contents(ROOTDIR.DS."resources" . DS. 'country' . DS. 'dist.countries.json');
        $countries = json_decode($str, TRUE);
        foreach($codes as $key => $code)
        {
            $codeC = explode('-', $code['code'])[0];
            if(empty($countries[$codeC]['name'])){
                $codes[$key]['fullname'] = $code['name'];
            } else {
                if($code['name'] != $countries[$codeC]['name']){
                    $codes[$key]['fullname'] = $countries[$codeC]['name'].' ('.$code['name'].')';
                } else {
                    $codes[$key]['fullname'] = $countries[$codeC]['name'];
                }
            }
        }

        $output = [];
        foreach($codes as $key => $data)
        {
            if(empty($data['fullname'])){
                continue;
            }
            $output[$data['fullname']] = $data;
        }

        ksort($output);
        return $output;
    }

}
