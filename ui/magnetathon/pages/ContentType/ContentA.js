import Link from 'next/link'

export default function ContentA() {
    return (
        <>
            <h1>Some categorized content!</h1>
            <h2>
                <Link href="/">
                    <a>Home</a>
                </Link>
            </h2>
        </>
    )
}