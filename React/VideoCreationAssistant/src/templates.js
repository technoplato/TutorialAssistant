export const devtoEventTemplate = `
{title} @ [{formattedStart}](https://youtu.be/{youtubeId}?t={start}) - \
[{formattedEnd}](https://youtu.be/{youtubeId}?t={end})

[![{title}]({screenshotUrl})](https://youtu.be/{youtubeId}?t={formattedStart} "{title}")

{description}
`

export const youtubeEventTemplate =
  '{formattedStart} - {formattedEnd} {title}\n{description}'

const devtoPostFooter = `
I really enjoy the process of creating interesting projects, deeply understanding what goes into making them work, and developing the ability to explain them to anyone interested! If you'd like to keep up to date with my projects, be sure to follow me here or anywhere I've linked below. 

I'm also getting ready to start back development on my open-source content aggregation platform where voting power is earned by competency, and competency is determined by answering fact-based community-moderated questions about the content that you're voting on. I'm also baking up a really cool cryptocurrency element into the project where one can choose to burn their voting power for a fungible cryptocurrency, kind of like a crypto kitty. 

Anyway, I've already blabbed on long enough. If you're interested in that project, check out the repo [here](https://github.com/technoplato/knophy) and send me a message anywhere! I think I could talk about this stuff all day!

[YouTube](https://www.youtube.com/c/michaellustig?sub_confirmation=1 )   |   [dev.to](https://dev.to/technoplato)   |   [Twitter](https://twitter.com/technoplato/)   |   [Github](https://github.com/technoplato)   |    [Medium](https://medium.com/@michaellustig)   |   [Reddit](https://www.reddit.com/user/halfjew22)
`

export const devtoPostTemplate = `
# {postTitle}

If this post was useful or interesting to you, please retweet or like!
{% twitter {tweetId} %}

Here's the video inline so you can check out the entire thing! If you'd rather skim, there are images with descriptions below that you can click. By default, those images link to where they occurred in the video so you can get a little more context. I feel like this is super helpful for the learning process.

At times, there are outside resources that I explore in the videos. If that's the case, clicking the image will actually take you to that particular resource. The timestamps for the video will always be linked above the post though if that's how you roll.

{% youtube {youtubeId} %}

{devtoPostBodyMarkdown}

${devtoPostFooter}

`
