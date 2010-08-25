
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>


#include <sphinxclient.h>


void epic_fail ( const char * template, ... )
{
	va_list ap;
	va_start ( ap, template );
	printf ( "FATAL: " );
	vprintf ( template, ap );
	printf ( "\n" );
	va_end ( ap );
	exit ( 1 );
}


void test_query ( sphinx_client * client, sphinx_bool test_extras )
{
	sphinx_result * res;
	const char *query, *index;
	int i, j, k;
	unsigned int * mva;
	const char * field_names[2];
	int field_weights[2];

	sphinx_uint64_t override_docid = 4;
	unsigned int override_value = 456;

	query = "test";
	index = "test1";

	field_names[0] = "title";
	field_names[1] = "content";
	field_weights[0] = 100;
	field_weights[1] = 1;
	sphinx_set_field_weights ( client, 2, field_names, field_weights );
	field_weights[0] = 1;
	field_weights[1] = 1;

	if ( test_extras )
	{
		sphinx_add_override ( client, "group_id", &override_docid, 1, &override_value );
		sphinx_set_select ( client, "*, group_id*1000+@id*10 AS q" );
	}

	res = sphinx_query ( client, query, index, NULL );
	if ( !res )
		epic_fail ( "query failed: %s", sphinx_error(client) );

	printf ( "Query '%s' retrieved %d of %d matches in %d.%03d sec.\n",
		query, res->total, res->total_found, res->time_msec/1000, res->time_msec%1000 );
	printf ( "Query stats:\n" );
	for ( i=0; i<res->num_words; i++ )
		printf ( "\t'%s' found %d times in %d documents\n",
		res->words[i].word, res->words[i].hits, res->words[i].docs );

	printf ( "\nMatches:\n" );
	for ( i=0; i<res->num_matches; i++ )
	{
		printf ( "%d. doc_id=%d, weight=%d", 1+i,
			(int)sphinx_get_id ( res, i ), sphinx_get_weight ( res, i ) );

		for ( j=0; j<res->num_attrs; j++ )
		{
			printf ( ", %s=", res->attr_names[j] );
			switch ( res->attr_types[j] )
			{
			case SPH_ATTR_MULTI | SPH_ATTR_INTEGER:
				mva = sphinx_get_mva ( res, i, j );
				printf ( "(" );
				for ( k=0; k<(int)mva[0]; k++ )
					printf ( k ? ",%u" : "%u", mva[1+k] );
				printf ( ")" );
				break;

			case SPH_ATTR_FLOAT:	printf ( "%f", sphinx_get_float ( res, i, j ) ); break;
			case SPH_ATTR_STRING:	printf ( "%s", sphinx_get_string ( res, i, j ) ); break;
			default:				printf ( "%u", (unsigned int)sphinx_get_int ( res, i, j ) ); break;
			}
		}

		printf ( "\n" );
	}
	printf ( "\n" );
}

int main ()
{
  printf ("Sphinx client stubs test .. \n") ; 
  sphinx_client * client;

  client = sphinx_create ( SPH_TRUE );

  if ( !client )
    epic_fail ( "failed to create client" );
  
  test_query ( client, SPH_FALSE );

  sphinx_destroy ( client );
  return 0 ; 
}
