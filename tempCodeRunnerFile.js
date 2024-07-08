
    db.get("SELECT isActive FROM activation_tokens WHERE parentEmail = ?", [email], (err, row) => {
        if (err) {
            console.error("Databa