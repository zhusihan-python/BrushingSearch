import os.path
import sqlite3

proj_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

platforms = """CREATE TABLE IF NOT EXISTS platforms (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name VARCHAR,
                deleted int DEFAULT (0),
                create_time DATETIME default (datetime('now', 'localtime')));"""

hotels = """CREATE TABLE IF NOT EXISTS hotels (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name VARCHAR NOT NULL,
                addr VARCHAR,
                tel VARCHAR,
                contacts VARCHAR,
                comment VARCHAR,
                deleted INTEGER DEFAULT (0),
                create_time DATETIME default (datetime('now', 'localtime')));"""

machines = """CREATE TABLE IF NOT EXISTS machines (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                number VARCHAR,
                telephone VARCHAR,
                person_name VARCHAR,
                card_type VARCHAR,
                card_fee VARCHAR,
                operator VARCHAR,
                create_time DATETIME default (datetime('now', 'localtime')));"""

machine_platform = """CREATE TABLE IF NOT EXISTS machine_platform (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        machine_id INTEGER,
                        platform_id INTEGER,
                        CONSTRAINT fk_machine
                        FOREIGN KEY (machine_id)
                        REFERENCES machines(id));"""

records = """CREATE TABLE IF NOT EXISTS records (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                platform VARCHAR NOT NULL,
                date VARCHAR,
                hotel VARCHAR,
                is_comment int default 0,
                payor VARCHAR,
                pay_channel VARCHAR,
                payment INTEGER,
                is_paid int default 0,
                resident VARCHAR NOT NULL,
                tel VARCHAR NOT NULL,
                machine_no INTEGER NOT NULL,
                ip_adrr VARCHAR,
                static_server VARCHAR,
                comments VARCHAR,
                deleted int default 0,
                create_time DATETIME default (datetime('now', 'localtime')));"""

images = """CREATE TABLE IF NOT EXISTS images (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    unique_id VARCHAR,
                    filepath VARCHAR NOT NULL,
                    deleted int default 0,
                    create_time DATETIME default (datetime('now', 'localtime')));"""

comment_screenshot = """CREATE TABLE IF NOT EXISTS comment_screenshot (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        image_id INTEGER,
                        records_id INTEGER,
                        CONSTRAINT fk_images
                        FOREIGN KEY (image_id)
                        REFERENCES images(id));"""

order_screenshot = """CREATE TABLE IF NOT EXISTS order_screenshot (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        image_id INTEGER,
                        records_id INTEGER,
                        CONSTRAINT fk_images
                        FOREIGN KEY (image_id)
                        REFERENCES images(id));"""


stmts = (platforms,
         hotels,
         machines,
         machine_platform,
         records,
         images,
         comment_screenshot,
         order_screenshot,)


def init_db():
    conn = sqlite3.connect(os.path.join(proj_root, "local.db"))
    cur = conn.cursor()

    try:
        for stmt in stmts:
            cur.execute(stmt)
        conn.commit()
        conn.close()
        print("finished")
    except Exception as e:
        print(e)


if __name__ == "__main__":
    init_db()
