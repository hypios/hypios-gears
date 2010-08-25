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

value ocaml_sphinx_set_server (value client_ocaml, value host_ocaml, value port_ocaml) 
{
  CAMLparam3 (client_ocaml, host_ocaml, port_ocaml);
  sphinx_client * client; 
  const char *host; 
  int port; 
  sphinx_bool res; 

  client = sphinx_client_val (client_ocaml);
  host = String_val (host_ocaml);
  port = Int_val (port_ocaml);
  
  res = sphinx_set_server (client, host, port) ;

  if ( !res ) 
    epic_fail ( "set_server failed: %s", sphinx_error(client) ); // Je **crois** qu'on retourne ds le runtime ocaml là
  
  CAMLreturn0; 
}


value value_of_int (int i) 
{
  return (Val_int (i));
}

value ocaml_sphinx_query (value client_ocaml, value index_ocaml, value query_ocaml) 
{
  CAMLparam3 (client_ocaml, index_ocaml, query_ocaml);
  sphinx_client * client; 
  sphinx_result * res;
  const char *query, *index;
  int i; 

  value res_ocaml ; 
  value words_ocaml ;
  value occurences_ocaml ; 

  client = sphinx_client_val (client_ocaml);
  index = String_val (index_ocaml);
  query = String_val (query_ocaml);
  
  res = sphinx_query ( client, query, index, NULL );

  if ( !res )
    epic_fail ( "query failed: %s", sphinx_error(client) ); // Je **crois** qu'on retourne ds le runtime ocaml là
  
  /* Triple check this part .. */

  res_ocaml = caml_alloc(6, 0) ; 
    
  Store_field ( res_ocaml, 0, ( Val_int ( res->total ) ) );
  Store_field ( res_ocaml, 1, ( Val_int ( res->total_found ) ) );
  Store_field ( res_ocaml, 2, ( Val_int ( res->num_words ) ) );

  words_ocaml = caml_alloc( res->num_words, 0);
  
  for ( i=0; i<res->num_words; i++ )
    {
      value wordinfo_ocaml ; 
      wordinfo_ocaml = caml_alloc(3, 0) ; 
      Store_field ( wordinfo_ocaml, 0, caml_copy_string ( res->words[i].word ) ) ;
      Store_field ( wordinfo_ocaml, 1, ( Val_int ( res->words[i].hits ) ) ) ;
      Store_field ( wordinfo_ocaml, 2, ( Val_int ( res->words[i].docs ) ) ) ;
      Store_field ( words_ocaml, i, wordinfo_ocaml ) ;
    }
  
  Store_field ( res_ocaml, 3, words_ocaml ) ;
  Store_field ( res_ocaml, 4, Val_int ( res-> num_matches ) ) ;
  
  occurences_ocaml = caml_alloc ( res-> num_matches, 0)  ;
  
  for ( i=0; i<res->num_matches; i++ )
    {
      value occurence_ocaml ; 
      occurence_ocaml = caml_alloc(2, 0) ;
      
      Store_field ( occurence_ocaml, 0, Val_int ( (int)sphinx_get_id ( res, i ) ) ) ;
      Store_field ( occurence_ocaml, 1, Val_int ( (int)sphinx_get_weight ( res, i ) ) ) ;
      
      Store_field ( occurences_ocaml, i, occurence_ocaml ) ;
    }
  
  Store_field ( res_ocaml, 5, occurences_ocaml ) ;
      
  CAMLreturn (res_ocaml); 
}
