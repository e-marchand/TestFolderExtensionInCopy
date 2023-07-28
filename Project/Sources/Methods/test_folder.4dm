//%attributes = {}



var $wd : 4D:C1709.Folder
$wd:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).folder(Generate UUID:C1066)

$wd.folder("dst").create()

$wd.folder("src").create()
$wd.folder("src").folder("folder.ext").create()
$wd.folder("src").copyTo($wd.folder("dst"))

ASSERT:C1129($wd.folder("dst").folder("src").exists)
ASSERT:C1129($wd.folder("dst").folder("src").folder("folder.ext").exists)

$wd.folder("ext.ext").create()
$wd.folder("ext.ext").folder("folder.ext").create()
$wd.folder("ext.ext").copyTo($wd.folder("dst"))

ASSERT:C1129($wd.folder("dst").folder("ext.ext").exists)
ASSERT:C1129($wd.folder("dst").folder("ext.ext").folder("folder.ext").exists)

If (Shift down:C543)
	SHOW ON DISK:C922($wd.platformPath)
Else 
	$wd.delete(Delete with contents:K24:24)
End if 