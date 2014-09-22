<?php

/*
Plugin Name: Unit Testing Demo Plugin
Plugin URI: http://voceplatforms.com
Description: Let's get started unit testing
Author: Mat Gargano, Voce Platforms
Version: 0.1
Author URI: http://voceplatforms.com
*/

class Demo_Plugin {

	public $listing;
	public $term_title;
	public $term_object;
	public $post_id;


	function init() {

		$this->attach_hooks();

	}

	function attach_hooks() {

		add_action( 'save_post', array( $this, 'categorize_post' ) );

	}

	function categorize_post( $post_id ) {


		if ( defined( 'DOING_AUTOSAVE' ) && DOING_AUTOSAVE ) {
			return;
		}

		if ( defined( 'DOING_AJAX' ) && DOING_AJAX ) {
			return;
		}

		if ( ! current_user_can( 'edit_post', $post_id ) ) {
			return;
		}

		if ( false !== wp_is_post_revision( $post_id ) ) {
			return;
		}

		$this->post_id = $post_id;
		$title         = get_the_title( $post_id );
		$this->get_listing();
		if ( count ( $this->listing ) ) {
			foreach ( $this->listing as $term_title ) {

				if ( strstr( $title, $term_title ) ) {

					$this->term_title = $term_title;
					$this->process_term();

				}

			}
		}

	}

	function process_term() {

		$this->term_object = get_term_by( 'name', $this->term_title, 'category' );

		if ( ! $this->term_object ) {
			$this->create_term();
		}

		if ( is_array( $this->term_object ) ) {

			wp_set_object_terms( $this->post_id, $this->term_object['term_id'], 'category', true );

		}


	}

	function create_term() {
		$this->term_object = wp_insert_term( $this->term_title, 'category' );

	}

	/**
	 * @codeCoverageIgnore
	 *
	 * Note: I could have not ignored this and used something like php-vcr (http://php-vcr.github.io/)
	 * however for the sake of simplicity and to demonstrate @codeCoverageIgnore I opted not to.
	 *
	 */
	function get_listing() {


		$request = wp_remote_get( 'http://myapi.com/apiendpoint' );

		$this->listing = json_decode( wp_remote_retrieve_body( $request ) );


	}


}

add_action( 'init', array( new Demo_Plugin, 'init' ) );
