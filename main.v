module main

import core

fn main() {
    println('Starting Velox...')

    mut engine := core.new_engine('velox.db') or {
        panic(err)
    }

    println('Velox ready.')

    // temporary console loop until GUI added
    for {
        print('Search> ')
        query := os.get_line()

        if query == 'exit' {
            break
        }

        results := engine.search(query)

        for r in results {
            println(r.file_ref)
        }
    }
}