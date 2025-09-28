import React, { useState, useEffect } from "react";
import axios from "axios";
const API_URL = "http://ec2-51-21-192-183.eu-north-1.compute.amazonaws.com/api";

interface User {
  id: string;
  email: string;
  name: string | null;
  createdAt: string;
}

function App() {
  // explicitly typed state
  const [users, setUsers] = useState<User[]>([]);
  const [email, setEmail] = useState<string>("");
  const [name, setName] = useState<string>("");
  const [loading, setLoading] = useState<boolean>(false);

  useEffect(() => {
    fetchUsers();
  }, []);

  const fetchUsers = async (): Promise<void> => {
    try {
      const response = (await axios.get(`${API_URL}/users`)) as any;
      setUsers(response.data);
    } catch (error) {
      console.error("Error fetching users:", error);
    }
  };

  const createUser = async (
    e: React.FormEvent<HTMLFormElement>
  ): Promise<void> => {
    e.preventDefault();
    if (!email) return;

    setLoading(true);
    try {
      await axios.post(`${API_URL}/api/users`, { email, name });
      setEmail("");
      setName("");
      await fetchUsers();
    } catch (error) {
      console.error("Error creating user:", error);
      alert("Error creating user. Please try again.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div style={{ padding: "20px", maxWidth: "800px", margin: "0 auto" }}>
      <h1>🚀 God Project - Vite + React + TypeScript</h1>

      <div
        style={{
          marginBottom: "30px",
          padding: "20px",
          border: "1px solid #ddd",
          borderRadius: "8px",
        }}
      >
        <h2>Add New User</h2>
        <form
          onSubmit={createUser}
          style={{ display: "flex", gap: "10px", flexWrap: "wrap" }}
        >
          <input
            type="email"
            placeholder="Email (required)"
            value={email}
            onChange={(e: React.ChangeEvent<HTMLInputElement>) =>
              setEmail(e.target.value)
            }
            required
            style={{ padding: "8px", flex: "1", minWidth: "200px" }}
          />
          <input
            type="text"
            placeholder="Name (optional)"
            value={name}
            onChange={(e: React.ChangeEvent<HTMLInputElement>) =>
              setName(e.target.value)
            }
            style={{ padding: "8px", flex: "1", minWidth: "200px" }}
          />
          <button
            type="submit"
            disabled={loading}
            style={{
              padding: "8px 16px",
              backgroundColor: loading ? "#ccc" : "#007bff",
              color: "white",
              border: "none",
              borderRadius: "4px",
              cursor: loading ? "not-allowed" : "pointer",
            }}
          >
            {loading ? "Adding..." : "Add User"}
          </button>
        </form>
      </div>

      <div>
        <h2>Users ({users.length})</h2>
        {users.length === 0 ? (
          <p>No users yet. Add one above!</p>
        ) : (
          <div style={{ display: "grid", gap: "10px" }}>
            {users.map((user: User) => (
              <div
                key={user.id}
                style={{
                  padding: "15px",
                  border: "1px solid #eee",
                  borderRadius: "4px",
                  backgroundColor: "#f9f9f9",
                }}
              >
                <div>
                  <strong>Email:</strong> {user.email}
                </div>
                <div>
                  <strong>Name:</strong> {user.name || "Not provided"}
                </div>
                <div style={{ fontSize: "0.8em", color: "#666" }}>
                  <strong>Created:</strong>{" "}
                  {new Date(user.createdAt).toLocaleString()}
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}

export default App;
