package com.hello;

import org.junit.Test;
import static org.junit.Assert.*;

public class HelloControllerTest {

    @Test
    public void testConcatenate() {
        HelloController myUnit = new HelloController();
        String result = myUnit.concatenate( "one", "two" );
        assertEquals( "onetwo", result );
    }

}
