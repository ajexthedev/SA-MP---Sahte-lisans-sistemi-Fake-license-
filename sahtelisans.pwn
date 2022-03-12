/* Author: ajeX
   Credits: TITAN
*/

#include <a_samp>
#include <sscanf2>

enum e_fakelicense
{
    bool:fakelicenseAuth,
    bool:havefakelicense,
    fakeName[24],
    fakeDriverLicense,
    fage[3],
    fgender,
    forigin[16],
    fsea_str[60],
    ffly_str[60]
};
new fklicense[MAX_PLAYERS][e_fakelicense];

CMD:slonay(playerid, params[])
{
    new targetid;

    if(sscanf(params,"u", targetid)) return SendClientMessage(playerid, -1, "KULLANIM: /slonay [ID]");

    fklicense[targetid][fakelicenseAuth] = true;

    SendClientMessage(playerid, -1, "Hedef oyuncuya onay verildi.");

    return 1;
}

CMD:sahtelisans(playerid, params[])
{
    new oneString[30], secString[90];

    if(sscanf(params, "s[30]S()[90]", oneString, secString))
    {
        SendClientMessage(playerid, 0xFF6347AA, "KULLANIM:{FFFFFF} /sahtelisans [parametre]");
        SendClientMessage(playerid, 0xFF6347AA, "[parametre] yardim, goster, ver");
        return 1;
    }

    if(!strcmp(oneString, "ver"))
    {
        new 
            targetid,
            license,
            name[24],
            origin[16],
            age,
            gender,
            sealicense,
            flylicense
        ;

        if(fklicense[playerid][fakelicenseAuth] == false) 
            return SendClientMessage(playerid, -1, "{ef7269}HATA:{ffffff} Bu komutu kullanmak için iznin yok.");

        if(sscanf(secString, "uiiidis[16]s[24]", targetid, license, sealicense, flylicense, age, gender, origin, name)) 
        {   
            SendClientMessageEx(playerid, 0xFF6347AA, "KULLANIM:{ffffff} /sahtelisans ver [oyuncu adı/ID] [sürücü(0/1)] [gemi(0/1)]");
            SendClientMessageEx(playerid, 0xFFFFFFFF, "[ucak(0/1)] [yaş] [cinsiyet(0/1)] [köken] [sahte ad]");
            return 1;
        }
        
        if(!IsPlayerConnected(targetid)) 
            return SendClientMessage(playerid, -1, "{ef7269}HATA:{ffffff} Geçersiz ID.");
        
        if(!YakinlikKontrol(playerid, targetid, 5.0)) 
            return SendClientMessage(playerid, -1, "{ef7269}HATA:{ffffff} Hedef ID'ye yakın değilsin.");

        if (license < 0 || license > 1) 
            return SendClientMessage(playerid, -1, "{ef7269}HATA:{ffffff} Sadece 0 ile 1 arasında değer girebilirsin.");

        if (sealicense < 0 || sealicense > 1) 
            return SendClientMessage(playerid, -1, "{ef7269}HATA:{ffffff} Sadece 0 ile 1 arasında değer girebilirsin.");

        if (flylicense < 0 || flylicense > 1) 
            return SendClientMessage(playerid, -1, "{ef7269}HATA:{ffffff} Sadece 0 ile 1 arasında değer girebilirsin.");

        if (gender < 0 || gender > 1) 
            return SendClientMessage(playerid, -1, "{ef7269}HATA:{ffffff} Sadece 0 ile 1 arasında değer girebilirsin.");

        fklicense[targetid][fakeName] = name;
        fklicense[targetid][forigin] = origin;
        fklicense[targetid][fakeDriverLicense] = license;
        fklicense[targetid][fage] = age;
        fklicense[targetid][fgender] = gender;
        fklicense[targetid][fsea_str] = sealicense;
        fklicense[targetid][ffly_str] = flylicense;
        fklicense[targetid][havefakelicense] = true;

        SendClientMessageEx(playerid, -1, "%s adlı kişiye sahte lisans verildi.", ReturnName(targetid));
    }
    else if(!strcmp(oneString, "goster"))
    {
        new 
            targetid;

        if(fklicense[playerid][havefakelicense] == false) return SendClientMessage(playerid, -1, "{ef7269}HATA:{ffffff} Gösterebileceğin bir sahte lisansın yok.");
    
        if(!YakinlikKontrol(playerid, targetid, 5.0)) return SendClientMessage(playerid, -1, "{ef7269}HATA:{ffffff} Kişiye yakın değilsin.");

        if(sscanf(secString, "u", targetid)) return SendClientMessage(playerid, -1, "/sahtelisans goster [oyuncu adı/ID]");
        {
            FakeLicense(playerid, targetid);

            return 1;
        }
    }
    else if(!strcmp(oneString, "yardim"))
    {
        SendClientMessage(playerid, 0x33AA33FF, "Sahte lisans verme komudu hakkında:");
        SendClientMessage(playerid, 0xa3a3a3ff, "[sürücü]: 0 Yok - 1 Var | [deniz]: 0 Yok - 1 Var | [uçuş]: 0 Yok - 1 Var");
        SendClientMessage(playerid, 0xdededeff, "[yaş]: 25 | [cinsiyet]: 0 Kadın - 1 Erkek");
        SendClientMessage(playerid, 0xa3a3a3ff, "[köken]: İngiltere | [sahte name]: John Doe");
        SendClientMessage(playerid, 0xdededeff, "___________________________________");
        return 1;
    }   
    return 1;
}

/* Fonksiyonlar */

stock YakinlikKontrol(playerid, targetid, Float:radius)
{
    static Float:fX, Float:fY, Float:fZ;
    GetPlayerPos(targetid, fX, fY, fZ);
    return (GetPlayerInterior(playerid) == GetPlayerInterior(targetid) && GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(targetid)) && IsPlayerInRangeOfPoint(playerid, radius, fX, fY, fZ);
}

stock FakeLicense(playerid, playerb)
{
    new
        driver_str[60],
        wep_str[60],
        sea_str[60],
        fly_str[60]
    ; 

    if(!fklicense[playerb][fakeDriverLicense])
        driver_str = "{FFFFFF}Sürücü Lisans: {cccccc}Yok";

    else driver_str = "{FFFFFF}Sürücü Lisansı: {cccccc}Var";

    if(!fklicense[playerb][fsea_str])
        sea_str = "{FFFFFF}Deniz lisans: {cccccc}Yok";

    else sea_str = "{FFFFFF}Deniz lisansı: {cccccc}Var";

    if(!fklicense[playerb][ffly_str])
        fly_str = "{FFFFFF}Uçuş lisansı: {cccccc}Yok";

    else fly_str = "{FFFFFF}Uçuş lisansı: {cccccc}Var";

    wep_str = "{FFFFFF}Ateşli silah lisansı: {cccccc}Yok";

    SendClientMessage(playerb, 0x38761dff, "____________________[Kimlik & Belgeler]____________________");
    SendClientMessageEx(playerb, 0xFFFFFFFF, "Vatandaşlık Numarası:{9f9f9f} G002"); /* Buraya sunucudaki kimlik id değişkeni eklenebilir veya random bir id oluşturulabilir. - PlayerData[playerid][pBlabla]*/
    SendClientMessageEx(playerb, 0xFFFFFFFF, "İsim:{cccccc} %s", fklicense[playerid][fakeName]);
    SendClientMessageEx(playerb, 0xFFFFFFFF, "Köken:{cccccc} %s", fklicense[playerid][forigin]);
    SendClientMessageEx(playerb, 0xFFFFFFFF, "Yaş:{cccccc} %d", fklicense[playerid][fage]);
    SendClientMessageEx(playerb, 0xFFFFFFFF, "Cinsiyet:{cccccc} %s", (fklicense[playerid][fgender] == 1) ? ("Erkek") : ("Kadın"));
    SendClientMessageEx(playerb, 0xFFFFFFFF, "%s - %s - %s", driver_str, sea_str, fly_str);
    SendClientMessageEx(playerb, 0xFFFFFFFF, "%s", wep_str);
    SendClientMessage(playerb, 0x38761dff, "____________________[Kimlik & Belgeler]____________________");

    return 1;
}

stock SendNearbyMessage(playerid, Float:range, color, message[]) {
	new Float:x,Float:y,Float:z;
	GetPlayerPos(playerid,x,y,z);
	foreach(Player, i) {
			if(GetPlayerInterior(i) == GetPlayerInterior(playerid) && GetPlayerVirtualWorld(i) == GetPlayerVirtualWorld(playerid)) {
			if(GetPlayerDistanceFromPoint(i,x,y,z) <= range) {
				SendClientMessage(i, color, message);
			}
		}
	}
	return 1;
}

stock ReturnName(playerid)
{
    new oyuncuisim[MAX_PLAYER_NAME];
    GetPlayerName(playerid, oyuncuisim, MAX_PLAYER_NAME);
    return oyuncuisim;
}

stock SendClientMessageEx(playerid, color, const text[], {Float, _}:...)
{
    static
        args,
        str[144];

    /*
     *  Custom function that uses #emit to format variables into a string.
     *  This code is very fragile; touching any code here will cause crashing!
    */
    if ((args = numargs()) == 3)
    {
        SendClientMessage(playerid, color, text);
    }
    else
    {
        while (--args >= 3)
        {
            #emit LCTRL 5
            #emit LOAD.alt args
            #emit SHL.C.alt 2
            #emit ADD.C 12
            #emit ADD
            #emit LOAD.I
            #emit PUSH.pri
        }
        #emit PUSH.S text
        #emit PUSH.C 144
        #emit PUSH.C str
        #emit PUSH.S 8
        #emit SYSREQ.C format
        #emit LCTRL 5
        #emit SCTRL 4

        SendClientMessage(playerid, color, str);

        #emit RETN
    }
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    fakelicenseAuth = false;
    havefakelicense = false;

    return 1;
}
