<?php
  require_once("libs/smarty/Smarty.class.php");
  require_once("libs/facebook/facebook.php");
  require_once("config.php");

  $facebook = new Facebook($appConfig);
  $myId = $facebook->getUser();
  
  if (!$myId) {
    header("Location: {$facebook->getLoginUrl(array("scope" => friends_relationships))}");
    exit;
  }

  $myProfile = $facebook->api('/me');
  file_put_contents("access.log", date("Y.m.d H:i:s") . "         " . $myProfile["name"] . "\n", FILE_APPEND);

  if ($myProfile["gender"] == "male") {
    $oppositeSex = "female";
  } elseif ($myProfile["gender"] == "female") {
    $oppositeSex = "male";
  } else {
    exit("Sorry, couldn't recognize your sex from your profile.");
  }

  $query = "SELECT name, pic_big, profile_url FROM user WHERE " . 
           "uid IN (SELECT uid2 FROM friend WHERE uid1 = '{$myId}') AND " . 
           "sex = '{$oppositeSex}' AND " . 
           "relationship_status = 'Single'";
  $friendList = $facebook->api(array("method" => "fql.query", "query" => $query));

  $smarty = new Smarty();
  $smarty->template_dir = "templates";
  $smarty->compile_dir = "templates_c";
  $smarty->left_delimiter = '{{';
  $smarty->right_delimiter = '}}';
  $smarty->assign("friendList", $friendList);
  $smarty->display("index.tpl");
?>
