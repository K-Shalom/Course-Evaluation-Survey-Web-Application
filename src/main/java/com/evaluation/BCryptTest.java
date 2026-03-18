import org.mindrot.jbcrypt.BCrypt;

public class BCryptTest {
    public static void main(String[] args) {
        String password = "Admin@1234";
        String hash = "$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lHni";
        System.out.println("Matches: " + BCrypt.checkpw(password, hash));
        
        String newHash = BCrypt.hashpw(password, BCrypt.gensalt(10));
        System.out.println("New Hash: " + newHash);
    }
}
