//%attributes = {}

var $wd : 4D:C1709.Folder
$wd:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).folder(Generate UUID:C1066)


var $archive : 4D:C1709.ZipArchive

$archName:="toto.zip"
$archFile:=Folder:C1567(fk resources folder:K87:11).file($archName)
$archive:=ZIP Read archive:C1637($archFile)

// 1/ ✅ when unzipping root, we expect an archive name as first folder (without extension ie .zip)
$wd.folder("dst/ext/root").create()
$archive.root.copyTo($wd.folder("dst/ext/root"))
ASSERT:C1129($wd.folder("dst/ext/root").folder($archFile.name).folder("folder.ext").exists)


// 2/ ❌ when unzipping content, we expect folders keep their extensions
$wd.folder("dst/ext/content").create()

$folder:=$archive.root.folder("folder.ext")
ASSERT:C1129($folder#Null:C1517; "folder.ext not found in archive")

$folder.copyTo($wd.folder("dst/ext/content"))

ASSERT:C1129($wd.folder("dst/ext/content").folder("folder.ext").exists; "No folder.ext inside "+Replace string:C233($wd.folder("dst/ext/content").path; $wd.path; "")+"\nInstead we have "+JSON Stringify:C1217($wd.folder("dst/ext/content").folders().map(Formula:C1597(Replace string:C233($1.value.path; $wd.path; "")))))

ASSERT:C1129(Not:C34($wd.folder("dst/ext/content").folder($archFile.name).folder("folder.ext").exists); "seems to have unarchived like a root instead of content")


// 3/ ❌ test with a folder inside
//$wd.folder("dst/ext/sub").create()
//$archive.root.folder("folder.ext").folder("another.4dbase").copyTo($wd.folder("dst/ext/sub"))
//ASSERT($wd.folder("dst/ext/sub").folder("another.4dbase").exists; "Same result folder loose its extension?")



// conclusion, we loose extension of zip folder where we apply copyTo
// I think we remove extension too much, we want maybe to do it for root instance (because of .zip)

// solution : make difference if root folder

If (Shift down:C543)
	SHOW ON DISK:C922($wd.platformPath)
Else 
	$wd.delete(Delete with contents:K24:24)
End if 