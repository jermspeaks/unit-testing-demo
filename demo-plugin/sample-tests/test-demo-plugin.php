<?php

class Demo_Test extends WP_UnitTestCase {

	/**
	 * @covers Demo_Plugin::init
	 */
	function test_init() {

		$demo_plugin = $this->getMockBuilder( 'Demo_Plugin' )
			->setMethods( array( 'attach_hooks' ) )
			->getMock();

		$demo_plugin->expects( $this->once() )
			->method( 'attach_hooks' );

		$demo_plugin->init();


	}

	/**
	 * @covers Demo_Plugin::attach_hooks
	 */
	function test_attach_hooks() {

		$demo_plugin = new Demo_Plugin;
		$demo_plugin->attach_hooks();

		$this->assertEquals( 10, has_action( 'save_post', array( $demo_plugin, 'categorize_post' ) ) );

	}


	function provider_test_categorize_post() {

		return array(
			array( 'Matt Harvey plays catch', 1 ),
			array( 'Everyone Happy that Matt Harvey has successful Bullpen Session', 1 ),
			array( 'Mets Lose, Daniel Murphy Shoulders the Blame', 1 ),
			array( 'Daniel Murphy and Matt Harvey Headline Mets Charity', 2 ),
			array( 'iON offers Mets fans a view never seen before', 0 ),
		);

	}

	/**
	 * @covers       Demo_Plugin::categorize_post
	 * @dataProvider provider_test_categorize_post
	 */
	function test_categorize_post( $title, $process_term_expects ) {

		$post_id = $this->factory->post->create( array( 'post_title' => $title ) );
		$user_id = $this->factory->user->create( array( 'role' => 'administrator' ) );
		wp_set_current_user( $user_id );

		$demo_plugin = $this->getMockBuilder( 'Demo_Plugin' )
			->setMethods( array( 'process_term', 'get_listing' ) )
			->getMock();

		$demo_plugin->expects( $this->exactly( $process_term_expects ) )
			->method( 'process_term' );

		$demo_plugin->expects( $this->once() )
			->method( 'get_listing' );


		$demo_plugin->listing = array( 'Matt Harvey', 'Daniel Murphy' );

		$demo_plugin->categorize_post( $post_id );


	}


	/**
	 * @covers Demo_Plugin::process_term
	 */
	function test_process_term() {

		$demo_plugin              = new Demo_Plugin;
		$demo_plugin->post_id     = $this->factory->post->create();
		$demo_plugin->term_title  = 'This is the title';
		$demo_plugin->term_object = false;
		$demo_plugin->process_term();
		$term = get_term_by( 'name', 'This is the title', 'category' );

		$this->assertNotFalse( $term );
		$this->assertTrue( has_category( $term, get_post( $demo_plugin->post_id ) ) );

	}


	/**
	 * @covers Demo_Plugin::create_term
	 */
	function test_create_term() {

		$demo_plugin             = new Demo_Plugin;
		$demo_plugin->term_title = 'Inserted Title';
		$demo_plugin->create_term();
		$term = get_term_by( 'name', 'Inserted Title', 'category' );
		$this->assertNotFalse( $term );


	}

}

