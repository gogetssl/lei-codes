<?php

spl_autoload_register(function ($className) {
    $prefix = 'LeiCodes\\Lib';
    $length = strlen($prefix);
    $baseDir = __DIR__.'/Lib/';
    if (strncmp($prefix, $className, $length) !== 0) {
        return;
    }
    $class = substr($className, $length);
    $file = $baseDir.str_replace('\\', '/', $class).'.php';
    if (file_exists($file)) {
        require_once $file;
    }
});
