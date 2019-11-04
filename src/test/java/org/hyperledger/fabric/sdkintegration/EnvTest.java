package org.hyperledger.fabric.sdkintegration;

import org.junit.Test;

public class EnvTest {

	@Test
	public void test() {
		System.setProperty("ORG_HYPERLEDGER_FABRIC_SDKTEST_VERSION", "1.4.0");
		String ORG_HYPERLEDGER_FABRIC_SDKTEST_VERSION = System.getenv("ORG_HYPERLEDGER_FABRIC_SDKTEST_VERSION");
		System.err.println(ORG_HYPERLEDGER_FABRIC_SDKTEST_VERSION);
	}
}
