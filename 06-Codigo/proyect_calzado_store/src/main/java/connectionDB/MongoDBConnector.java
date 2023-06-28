import com.mongodb.MongoClient;
import com.mongodb.MongoClientURI;
import com.mongodb.client.MongoDatabase;

public class MongoDBConnector {
    private static final String DATABASE_NAME = "calzados_store";
    private MongoClient mongoClient;
    private MongoDatabase database;

    public MongoDBConnector() {
        // Configurar la URI de conexión
        String connectionString = "mongodb+srv://admin_db:tSAy7QHqmwcrAafy@cluster0.qltezap.mongodb.net/" + DATABASE_NAME + "?retryWrites=true&w=majority";

        // Crear el cliente de MongoDB
        mongoClient = new MongoClient(new MongoClientURI(connectionString));

        // Conectarse a la base de datos
        database = mongoClient.getDatabase(DATABASE_NAME);
    }

    public MongoDatabase getDatabase() {
        return database;
    }

    public void closeConnection() {
        // Cerrar la conexión con MongoDB
        mongoClient.close();
    }
}
