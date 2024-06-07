@echo off
chcp 65001 >nul

echo Installation/Mise a jour de houineaura...
ping -n 2 127.0.0.1 > nul

:: Definir les chemins
set "DownloadURL=https://github.com/KevinDSM/houineaura/raw/main/houineaura.zip"
set "DownloadFile=%temp%\houineaura.zip"
set "WeakAuraDir=houineaura"
set "ImportFile=import.txt"

:: Telecharger le dossier compresse sur le bureau
echo Telechargement du dossier houineaura...
powershell -Command "Invoke-WebRequest -Uri '%DownloadURL%' -OutFile '%DownloadFile%'" 2>nul || (
    echo ERREUR: Impossible de telecharger le dossier houineaura.
    pause
    exit /b 1
)

:: Chercher le repertoire d'interface de WoW sur le disque D
if exist "D:\Program Files (x86)\World of Warcraft\_retail_\Interface" (
    set "WoWInterfaceDir=D:\Program Files (x86)\World of Warcraft\_retail_\Interface"
    goto foundWoWInterfaceDir
)

if exist "D:\World of Warcraft\_retail_\Interface" (
    set "WoWInterfaceDir=D:\World of Warcraft\_retail_\Interface"
    goto foundWoWInterfaceDir
)

:: Si non trouve sur D, chercher sur C (au cas ou)
for %%d in (C) do (
    if exist "%%d:\Program Files (x86)\World of Warcraft\_retail_\Interface" (
        set "WoWInterfaceDir=%%d:\Program Files (x86)\World of Warcraft\_retail_\Interface"
        goto foundWoWInterfaceDir
    )

    if exist "%%d:\World of Warcraft\_retail_\Interface" (
        set "WoWInterfaceDir=%%d:\World of Warcraft\_retail_\Interface"
        goto foundWoWInterfaceDir
    )
)

echo ERREUR: Impossible de trouver le repertoire d'interface de World of Warcraft.
pause
exit /b 1

:foundWoWInterfaceDir
echo Le repertoire WoWInterfaceDir a ete trouve : %WoWInterfaceDir%

:: Extraire le dossier sur le bureau
echo Extraction du dossier houineaura...
echo Chemin du fichier ZIP : %DownloadFile%
powershell -command "Expand-Archive '%DownloadFile%' '%userprofile%\Desktop'" 2>nul || (
    echo ERREUR: Impossible d'extraire le dossier houineaura.
    pause
    exit /b 1
)

:: Supprimer les anciens dossiers s'ils existent
if exist "%WoWInterfaceDir%\%WeakAuraDir%" (
    echo Suppression de ton ancien dossier houineaura...
    rmdir /S /Q "%WoWInterfaceDir%\%WeakAuraDir%"
    ping -n 2 127.0.0.1 > nul
)

if exist "%WoWInterfaceDir%\pedrolust" (
    echo Suppression de ton ancien dossier pedrolust...
    rmdir /S /Q "%WoWInterfaceDir%\pedrolust"
    ping -n 2 127.0.0.1 > nul
)

:: Copier le dossier houineaura extrait vers le repertoire Interface
echo Copie du dossier houineaura vers Interface...
xcopy /E /Y /I /Q "%userprofile%\Desktop\houineaura-main\%WeakAuraDir%\*" "%WoWInterfaceDir%\%WeakAuraDir%" > nul || (
    echo ERREUR: Impossible de copier le dossier houineaura.
    pause
    exit /b 1
)

:: Copier le contenu du fichier import.txt dans le presse-papiers
echo Copie du texte d'import dans ton presse-papiers...
clip < "%userprofile%\Desktop\houineaura-main\%WeakAuraDir%\import.txt"
ping -n 2 127.0.0.1 > nul
echo Derniere etape: Ouvre WeakAura en jeu et importe le texte copie.

:: Supprimer le dossier telecharge et extrait du bureau
echo Suppression des fichiers temporaires...
rmdir /S /Q "%userprofile%\Desktop\houineaura-main"
del "%DownloadFile%"
del "%userprofile%\Desktop\import.txt"

ping -n 2 127.0.0.1 > nul
echo Mise a jour terminee !
ping -n 2 127.0.0.1 > nul

:: Rappel des etapes finales
echo ----------------------------------------------------------------------------
echo 1) Colle le texte du presse-papier sur WeakAura en jeu dans "Importer".
echo N'oublie pas de supprimer l'ancien houineaura !
echo ----------------------------------------------------------------------------
echo 2) Tous les fichiers necessaires ont ete copies dans le repertoire Interface.
echo ----------------------------------------------------------------------------

:: Message final avec le nom d'utilisateur
echo Appuie sur Entree pour fermer, %username%...
pause >nul
