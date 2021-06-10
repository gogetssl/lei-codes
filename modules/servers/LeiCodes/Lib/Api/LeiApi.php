<?php

namespace LeiCodes\Lib\Api;

class LeiApi
{
    const URL = 'https://api.gleif.org/api/v1/autocompletions?field=fulltext&q=';

    public static function call($entityId)
    {
       $data = json_decode(file_get_contents(self::URL.$entityId));
       logModuleCall('LeiCodes - LEI API', 'GET LEI Code', self::URL.$entityId, $data);
        if($data->data[0]->relationships->{'lei-records'}->data->type == 'lei-records' && !empty($data->data[0]->relationships->{'lei-records'}->data->id))
       {
           return ['code' => 1, 'lei' => $data->data[0]->relationships->{'lei-records'}->data->id];
       }
       return ['code' => 0];
    }
}