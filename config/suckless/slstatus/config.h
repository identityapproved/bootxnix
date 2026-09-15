/* See LICENSE file for copyright and license details. */
/* bootxnix: full config, copied over config.def.h at build time. Only the
   args[] block differs from upstream: cpu / ram / datetime. */

/* interval between updates (in ms) */
const unsigned int interval = 1000;

/* text to show if no value can be retrieved */
static const char unknown_str[] = "n/a";

/* maximum output string length */
#define MAXLEN 2048

static const struct arg args[] = {
	/* function     format          argument */
	{ cpu_perc,     "  %s%% cpu ",  NULL },
	{ ram_perc,     " %s%% ram ",   NULL },
	{ datetime,     " %s ",         "%d.%m.%Y %H:%M" },
};
