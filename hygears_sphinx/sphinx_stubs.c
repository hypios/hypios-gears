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


value ocaml_sphinx_set_field_weights (value client_ocaml, value fields_number_ocaml, value field_names_ocaml, value field_weights_ocaml)
{
  CAMLparam4 (client_ocaml, fields_number_ocaml, field_names_ocaml, field_weights_ocaml); 
  
  sphinx_client * client ; 
  int fields_number ;
  
  char ** field_names; 
  int * field_weights;
  
  int i ;

  client = sphinx_client_val (client_ocaml);
 
  fields_number = Int_val (fields_number_ocaml) ;
  
  field_names = (char **) malloc (sizeof (char *) * fields_number); 
  
  field_weights = (int *) malloc (sizeof (int) * fields_number); 
  
  for ( i=0; i<fields_number; i++ )
    {
      field_names[i] = String_val (Field(field_names_ocaml, i)) ;
      field_weights[i] = Int_val (Field(field_weights_ocaml, i)) ;
    }
  
  sphinx_set_field_weights ( client, fields_number, field_names, field_weights );
  
  CAMLreturn0;
}

value ocaml_sphinx_set_select (value client_ocaml, value select_ocaml)
{
  CAMLparam2 (client_ocaml, select_ocaml); 
  sphinx_client * client;
  char * select ; 
  
  client = sphinx_client_val (client_ocaml);
  select = String_val (select_ocaml) ; 
  
  sphinx_set_select ( client, select );
  
  CAMLreturn0;
}

value ocaml_sphinx_set_limits (value client_ocaml, value offset_ocaml, value limit_ocaml, value max_matches_ocaml, value cutoff_ocaml)
{
  CAMLparam5 (client_ocaml, offset_ocaml, limit_ocaml, max_matches_ocaml, cutoff_ocaml); 
  sphinx_client * client;
  int offset, limit, max_matches, cutoff ;
  
  client = sphinx_client_val (client_ocaml);

  offset = Int_val (offset_ocaml) ; 
  limit = Int_val (limit_ocaml) ; 
  max_matches = Int_val (max_matches_ocaml) ; 
  cutoff = Int_val (cutoff_ocaml) ; 
   
  if (!sphinx_set_limits (client, offset, limit, max_matches, cutoff)) epic_fail ( "set_server failed: %s", sphinx_error(client) );
 
  CAMLreturn0;
}

value ocaml_sphinx_query (value client_ocaml, value index_ocaml, value query_ocaml) 
{
  CAMLparam3 (client_ocaml, index_ocaml, query_ocaml);
  sphinx_client * client; 
  sphinx_result * res;
  const char *query, *index;
  int i, j, k; 

  
  unsigned int * mva;
  
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
      occurence_ocaml = caml_alloc(3, 0) ;
      
      Store_field ( occurence_ocaml, 0, Val_int ( (int)sphinx_get_id ( res, i ) ) ) ;
      Store_field ( occurence_ocaml, 1, Val_int ( (int)sphinx_get_weight ( res, i ) ) ) ;
      
      // Create attributes array
       value attributes_ocaml ;
       attributes_ocaml = caml_alloc( res->num_attrs, 0) ;
       
       for ( j=0; j<res->num_attrs; j++ )
	 {
	   value attribute_ocaml ;
	   attribute_ocaml = caml_alloc(2, 0) ;
	   Store_field ( attribute_ocaml, 0, caml_copy_string ( res->attr_names[j] ) ) ; 

	   switch ( res->attr_types[j] )
	     {
	     case SPH_ATTR_MULTI | SPH_ATTR_INTEGER:
	       
	       mva = sphinx_get_mva ( res, i, j );
	       
	       value mva_ocaml ; 
	       mva_ocaml = caml_alloc( (int)mva[0], 0) ;  //  O = IntArray
    	       
	       for ( k=0; k<(int)mva[0]; k++ )
		 Store_field ( mva_ocaml, k, caml_copy_int32( mva[1+k] ) ) ; 

	       Store_field ( attribute_ocaml, 1, mva_ocaml ) ; 

	       break; 
	     case SPH_ATTR_FLOAT:
	       {
		 value float_ocaml ;
		 float_ocaml = caml_alloc(1, 1) ; // 1  = Float 
		 Store_field ( float_ocaml, 0, caml_copy_double(  sphinx_get_float ( res, i, j ) ) ) ; 
		 Store_field ( attribute_ocaml, 1, float_ocaml ) ;
		 break;
	       }
	     case SPH_ATTR_STRING:	
	       {
		 value string_ocaml; 
		 string_ocaml = caml_alloc (1, 2) ; // 2 = String 
		 Store_field ( string_ocaml, 0, caml_copy_string( sphinx_get_string ( res, i, j ) ) ) ; 
		 Store_field ( attribute_ocaml, 1, string_ocaml ) ; 
		 break; 
	       }
	     default:
	       {
		 value int_ocaml; 
		 int_ocaml = caml_alloc (1, 3) ; // 3 = String 
		 Store_field ( int_ocaml, 0,  caml_copy_int32(  (unsigned int)sphinx_get_int ( res, i, j ) ) ) ; 
		 Store_field ( attribute_ocaml, 1, int_ocaml ) ; 
		 break;
	       }
	       }

	   Store_field ( attributes_ocaml, j, attribute_ocaml);  
	   
	 }

       Store_field ( occurence_ocaml, 2, attributes_ocaml ); 
            
       Store_field ( occurences_ocaml, i, occurence_ocaml ) ;
    }
  
  Store_field ( res_ocaml, 5, occurences_ocaml ) ;
      
  CAMLreturn (res_ocaml); 
}
