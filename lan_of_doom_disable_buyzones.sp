#include <sdktools>
#include <sourcemod>

public const Plugin myinfo = {
    name = "Disable Buyzones", author = "LAN of DOOM",
    description = "Disables buyzones", version = "1.0.0",
    url = "https://github.com/lanofdoom/counterstrikesource-disable-buyzones"};

static const char kBuyZoneEntityName[] = "func_buyzone";

static ConVar g_buyzones_disabled_cvar;

//
// Logic
//

static void UpdateEntities(const char[] classname, const char[] action) {
  int index = FindEntityByClassname(INVALID_ENT_REFERENCE, classname);
  while (index != INVALID_ENT_REFERENCE) {
    AcceptEntityInput(index, action);
    index = FindEntityByClassname(index, classname)
  }
}

static void EnableBuyzones() { UpdateEntities(kBuyZoneEntityName, "Enable"); }

static void DisableBuyzones() { UpdateEntities(kBuyZoneEntityName, "Disable"); }

//
// Hooks
//

static Action OnRoundStart(Handle event, const char[] name,
                           bool dontBroadcast) {
  if (!GetConVarBool(g_buyzones_disabled_cvar)) {
    return Plugin_Continue;
  }

  DisableBuyzones();

  return Plugin_Continue;
}

static void OnCvarChange(Handle convar, const char[] old_value,
                         const char[] new_value) {
  if (GetConVarBool(convar)) {
    DisableBuyzones();
  } else {
    EnableBuyzones();
  }
}

//
// Forwards
//

public void OnPluginStart() {
  g_buyzones_disabled_cvar =
      CreateConVar("sm_lanofdoom_buyzones_disabled", "1",
                   "If true, buyzones are disabled.");

  HookConVarChange(g_buyzones_disabled_cvar, OnCvarChange);
  HookEvent("round_start", OnRoundStart);

  if (!GetConVarBool(g_buyzones_disabled_cvar)) {
    return;
  }

  DisableBuyzones();
}

public void OnPluginEnd() {
  if (!GetConVarBool(g_buyzones_disabled_cvar)) {
    return;
  }

  EnableBuyzones();
}