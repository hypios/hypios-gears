/*
 * hyGears - sphinx
 *
 * (c) 2010 William Le Ferrand william.le-ferrand@polytechnique.edu
 *
 * sphinx_stubs.c 24 08 2010 02:36
 *
 */

#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>

// OCAML 
#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>
#include <caml/fail.h>
#include <caml/custom.h>

// SPHINX 
#include <sphinxclient.h>



/********************************/
/* Dealing with 'sphinx_client' */
/********************************/

static struct custom_operations sphinx_client_ops = {
  "hypios.hygears_sphinx.client",
  custom_finalize_default,
  custom_compare_default,
  custom_hash_default,
  custom_serialize_default,
  custom_deserialize_default
};

/* Accessing the sphinx_client * part of a Caml custom block */
#define sphinx_client_val(v) (*((sphinx_client **) Data_custom_val(v)))

/* Allocating a Caml custom block to hold the given sphinx_client */
static value alloc_sphinx_client(sphinx_client * c)
{
  value v = alloc_custom(&sphinx_client_ops, sizeof(sphinx_client *), 0, 1);
  sphinx_client_val(v) = c;
  return v;
}



void epic_fail ( const char * template, ... )
{
  va_list ap;
  va_start ( ap, template );
  printf ( "FATAL: " );
  vprintf ( template, ap );
  printf ( "\n" );
  va_end ( ap );
  caml_failwith("Fatal error in sphinx ... Check stdout for more info");
}

value ocaml_sphinx_connect (value unit) 
{
  CAMLparam1 (unit); 
  sphinx_client * client; 

  client = sphinx_create ( SPH_TRUE );
  CAMLreturn (alloc_sphinx_client (client)); 
}


value ocaml_sphinx_query (value client_ocaml, value index_ocaml, value query_ocaml) 
{
  CAMLparam3 (client_ocaml, index_ocaml, query_ocaml);
  sphinx_client * client; 
  sphinx_result * res;
  const char *query, *index;

  client = sphinx_client_val (client_ocaml);
  index = String_val (index_ocaml);
  query = String_val (query_ocaml);
  
  res = sphinx_query ( client, query, index, NULL );

  if ( !res )
    epic_fail ( "query failed: %s", sphinx_error(client) ); // Je **crois** qu'on retourne ds le runtime ocaml là
  
  printf ( "Query '%s' retrieved %d of %d matches in %d.%03d sec.\n",
	   query, res->total, res->total_found, res->time_msec/1000, res->time_msec%1000 ); 
  
  CAMLreturn0; 
}

/*

int main ()
{
	sphinx_client * client;

		net_init ();

	client = sphinx_create ( SPH_TRUE );
	if ( !client )
		die ( "failed to create client" );

	test_query ( client, SPH_FALSE );
	test_excerpt ( client );
	test_update ( client, 75 );
	test_update_mva ( client );
	test_query ( client, SPH_FALSE );
	test_keywords ( client );
	test_query ( client, SPH_TRUE );

	sphinx_open ( client );
	test_update ( client, 688 );
	test_update ( client, 252 );
	test_query ( client, SPH_FALSE );
	sphinx_cleanup ( client );
	test_query ( client, SPH_FALSE );

	sphinx_close ( client );

	test_status ( client );

	sphinx_destroy ( client );
	
	return 0;
}

*/
