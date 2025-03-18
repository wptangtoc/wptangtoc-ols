<?php

if ( isset($_SERVER['argv'][1])){
	$unicodeDomain = $_SERVER['argv'][1];
}
$punycodeDomain = idn_to_ascii($unicodeDomain, 0, INTL_IDNA_VARIANT_UTS46); // INTL_IDNA_VARIANT_UTS46 is recommended
echo "$punycodeDomain"; 
?>
