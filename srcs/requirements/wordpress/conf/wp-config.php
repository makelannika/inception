<?php

define('WORDPRESS_DB_NAME', getenv('WORDPRESS_DB_NAME'));
define('WORDPRESS_DB_USER', getenv('WORDPRESS_DB_USER'));
define('WORDPRESS_DB_PASSWORD', getenv('WORDPRESS_DB_PASSWORD'));
define('WORDPRESS_DB_HOST', getenv('WORDPRESS_DB_HOST'));
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');

$table_prefix = 'wp_';

if ( !defined('ABSPATH') )
	define( 'ABSPATH', dirname(__FILE__) . '/' );

require_once(ABSPATH . 'wp-settings.php');
