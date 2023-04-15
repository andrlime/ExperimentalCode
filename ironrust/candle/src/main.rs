use std::error::Error;
mod models;
mod db;
use warp::Filter;
use tokio;

#[tokio::main]
async fn main() -> Result<(), Box<dyn Error>> {            
    let client = db::init().await?;
    println!("✅ Database connected successfully");

    let judges = client.database("judges").collection("judges");
    let judge: models::Judge = judges
        .find_one(
            bson::doc! {
                "name": "Hassan Whitfield"
            },
            None,
        ).await?
        .expect("Missing document.");
    println!("Judge: {}", judge.name);
    
    // GET /hello/warp => 200 OK with body "Hello, warp!"
    let hello = warp::path!("hello" / String)
        .map(|name| format!("Hello, {}!", name));
    
    warp::serve(hello)
        .run(([127, 0, 0, 1], 3030))
        .await;

   Ok(())
}
