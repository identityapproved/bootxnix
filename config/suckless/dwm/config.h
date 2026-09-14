/* bootxnix dwm config.h - based on the archived dwmwmvm config, with:
 *   - Rose Pine colours
 *   - MODKEY = Alt (Mod1), so nothing clashes with a Super-based compositor
 *   - keybindings mapped to the lainland (mango) muscle memory
 * See LICENSE file for copyright and license details. */

/* appearance */
static const unsigned int borderpx  = 1;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const char *fonts[]          = { "AnonymicePro Nerd Font:size=10" };
static const char dmenufont[]       = "AnonymicePro Nerd Font:size=10";

/* Rose Pine (main) */
static const char col_base[]        = "#191724"; /* bar / normal bg */
static const char col_hmed[]        = "#403d52"; /* normal border */
static const char col_subtle[]      = "#908caa"; /* normal fg */
static const char col_text[]        = "#e0def4"; /* selected fg */
static const char col_love[]        = "#eb6f92"; /* selected bg + border */

static const char *colors[][3]      = {
	/*               fg           bg         border   */
	[SchemeNorm] = { col_subtle,  col_base,  col_hmed },
	[SchemeSel]  = { col_text,    col_love,  col_love },
};

/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class               instance  title           tags mask  isfloating  monitor */
	{ "firefox",           NULL,     NULL,           1 << 1,    0,          -1 },
	{ "Chromium-browser",  NULL,     NULL,           1 << 1,    0,          -1 },
	{ "Chromium",          NULL,     NULL,           1 << 1,    0,          -1 },
	{ "Brave-browser",     NULL,     NULL,           1 << 1,    0,          -1 },
	{ "zen",               NULL,     NULL,           1 << 1,    0,          -1 },
	{ "zen-beta",          NULL,     NULL,           1 << 1,    0,          -1 },
	{ "Tor Browser",       NULL,     NULL,           1 << 2,    0,          -1 },
	{ "OWASP ZAP",         NULL,     NULL,           1 << 3,    0,          -1 },
	{ "zap-ZAP",           NULL,     NULL,           1 << 3,    0,          -1 },
	{ "Pinentry",          NULL,     NULL,           0,         1,          -1 },
};

/* layout(s) */
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
};

/* key definitions */
#define MODKEY Mod1Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} };

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* step to the previous (i<0) / next (i>0) tag, wrapping around */
static void
shiftview(const Arg *arg)
{
	Arg s;
	unsigned int cur = selmon->tagset[selmon->seltags];
	if (arg->i > 0)
		s.ui = (cur << arg->i) | (cur >> (LENGTH(tags) - arg->i));
	else
		s.ui = (cur >> (-arg->i)) | (cur << (LENGTH(tags) + arg->i));
	s.ui &= (1 << LENGTH(tags)) - 1;
	view(&s);
}

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", col_base, "-nf", col_subtle, "-sb", col_love, "-sf", col_text, NULL };
static const char *termcmd[]  = { "st", NULL };
static const char *tmuxcmd[]  = { "st", "-e", "tmux", "new-session", "-A", "-s", "main", NULL };
static const char *filescmd[] = { "st", "-e", "yazi", NULL };

static const Key keys[] = {
	/* modifier                     key        function        argument */
	{ MODKEY,                       XK_space,  spawn,          {.v = dmenucmd } },
	{ MODKEY,                       XK_Return, spawn,          {.v = tmuxcmd } },
	{ MODKEY|ShiftMask,             XK_Return, spawn,          {.v = termcmd } },
	{ MODKEY,                       XK_e,      spawn,          {.v = filescmd } },
	{ MODKEY,                       XK_w,      spawn,          SHCMD("feh --no-fehbg --randomize --bg-fill /etc/bootxnix/wallpapers") },
	{ MODKEY,                       XK_b,      togglebar,      {0} },
	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_l,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_h,      focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_Tab,    focusstack,     {.i = +1 } },
	{ MODKEY|ControlMask|ShiftMask, XK_h,      setmfact,       {.f = -0.05} },
	{ MODKEY|ControlMask|ShiftMask, XK_l,      setmfact,       {.f = +0.05} },
	{ MODKEY|ControlMask|ShiftMask, XK_k,      incnmaster,     {.i = +1 } },
	{ MODKEY|ControlMask|ShiftMask, XK_j,      incnmaster,     {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_h,      zoom,           {0} },
	{ MODKEY|ShiftMask,             XK_j,      zoom,           {0} },
	{ MODKEY|ShiftMask,             XK_k,      zoom,           {0} },
	{ MODKEY|ShiftMask,             XK_l,      zoom,           {0} },
	{ MODKEY,                       XK_q,      killclient,     {0} },
	{ MODKEY,                       XK_v,      togglefloating, {0} },
	{ MODKEY,                       XK_f,      setlayout,      {.v = &layouts[2]} }, /* monocle */
	{ MODKEY,                       XK_n,      setlayout,      {0} },                /* cycle */
	{ MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
	{ MODKEY,                       XK_comma,  shiftview,      {.i = -1 } },
	{ MODKEY,                       XK_period, shiftview,      {.i = +1 } },
	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)
	{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};
