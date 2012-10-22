// Pmd5 v 0.01
// (c) Martin Schneider 2012
//

package perceptify.pmd5;
import processing.core.*;

public class Pmd5 {

	public static String encode( String data ) {

		java.security.MessageDigest digest = null;
		try {
			digest = java.security.MessageDigest.getInstance("MD5");
		} 
		catch ( java.security.NoSuchAlgorithmException nsae ) {
			nsae.printStackTrace();
		}
		digest.update( data.getBytes() );
		byte[] hash = digest.digest();

		StringBuilder hexed = new StringBuilder();

		for ( int i = 0; i < hash.length; i++ ) 
		{
			hexed.append( PApplet.hex( hash[i], 2 ) );
		}

		return hexed.toString().toLowerCase();

	}

}


