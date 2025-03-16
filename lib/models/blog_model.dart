class BlogPost {
  final String id;
  final String authorName;
  final String authorImage;
  final String title;
  final List<String> images;
  final String content;
  final DateTime publishTime;

  BlogPost({
    required this.id,
    required this.authorName,
    required this.authorImage,
    required this.title,
    required this.images,
    required this.content,
    required this.publishTime,
  });
}

// Sample static data
final List<BlogPost> blogPosts = [
  BlogPost(
    id: '1',
    authorName: 'Warren Buffet',
    authorImage: 'assets/blog/profile.png',
    title: 'Apple Is Now Worth \$3 Trillion, Boosted By The Halo Of Beat',
    images: ['assets/blog/content.png', 'assets/blog/content2.png'],
    content: '''
        In a remarkable milestone for the technology industry, Apple Inc. has achieved a market capitalization of \$3 trillion, marking a historic moment in corporate valuation. This unprecedented achievement comes as the company continues to demonstrate strong performance across its product lines and services, solidifying its position as one of the most valuable and influential companies in the world.

        The company's success can be attributed to several factors, including its innovative product lineup, growing services revenue, and strong brand loyalty among consumers. The iPhone, in particular, continues to be a major driver of Apple's growth, with the latest models showcasing advanced features and capabilities that maintain the company's competitive edge in the smartphone market.

        Apple's services division, including Apple Music, iCloud, and the App Store, has emerged as a crucial revenue stream, contributing significantly to the company's bottom line. The acquisition of Beats by Dre and its subsequent integration into Apple's ecosystem has proven to be a strategic masterpiece, enhancing both the company's hardware offerings and its streaming services.

        Market analysts point to Apple's consistent innovation in product design and user experience as key factors in its valuation growth. The company's ability to create seamless integration between its devices and services has created a powerful ecosystem that keeps customers engaged and loyal to the brand.

        The impact of Apple's success extends beyond its immediate business operations. The company's massive market capitalization has significant implications for index funds and institutional investors, as Apple's stock performance can substantially influence broader market trends. Additionally, Apple's strong financial position enables continued investment in research and development, potentially leading to groundbreaking new products and services in the future.

        Looking ahead, Apple faces both opportunities and challenges. The company must navigate increasing competition in the smartphone market, potential regulatory scrutiny, and the need to maintain its innovative edge. However, with its strong brand, loyal customer base, and substantial financial resources, Apple appears well-positioned to continue its growth trajectory.

        The achievement of a \$3 trillion market cap represents not just a milestone for Apple, but a testament to the potential of technology companies to create unprecedented value in the modern economy. As Apple continues to push boundaries and explore new markets, the company's journey serves as an inspiration for entrepreneurs and businesses worldwide.
    ''',
    publishTime: DateTime.now(),
  ),
  BlogPost(
    id: '2',
    authorName: 'Elon Musk',
    authorImage: 'assets/blog/profile.png',
    title: 'SpaceX’s Starship Successfully Completes Test Flight',
    images: ['assets/blog/content.png', 'assets/blog/content2.png'],
    content: '''
        SpaceX has successfully completed a groundbreaking test flight of its massive Starship rocket, marking a pivotal moment in the company's ambitious journey toward interplanetary travel. The test, which took place at the company's facility in Boca Chica, Texas, demonstrated significant improvements in the spacecraft's capabilities and brought humanity one step closer to becoming a multi-planetary species.

        The latest test flight showcased several crucial technological advancements, including more efficient Raptor engines and an upgraded heat shield designed to withstand the extreme temperatures of atmospheric re-entry. These improvements represent major steps forward in SpaceX's goal of creating a fully reusable spacecraft capable of carrying both cargo and crew to distant destinations.

        One of the most notable achievements during the test was the successful demonstration of Starship's innovative propulsion system. The spacecraft's engines performed flawlessly, delivering precise control and optimal fuel efficiency throughout all phases of flight. This breakthrough in engine technology sets new standards for the aerospace industry and opens up possibilities for more ambitious space missions.

        The test flight also validated SpaceX's innovative approach to spacecraft design and construction. The company's rapid prototyping methodology and willingness to learn from previous failures have resulted in a robust and capable vehicle. The Starship's stainless steel construction, once considered unconventional, has proven to be both cost-effective and technically superior for this application.

        Looking beyond this successful test, SpaceX's Starship program has far-reaching implications for the future of space exploration. The vehicle's massive payload capacity and full reusability could dramatically reduce the cost of accessing space, potentially enabling regular missions to the Moon, Mars, and beyond. This capability aligns perfectly with NASA's Artemis program and other international space exploration initiatives.

        The economic implications of Starship's success are equally significant. By drastically reducing launch costs, SpaceX could revolutionize various industries, from satellite deployment to space tourism. The company's achievement has already attracted attention from potential commercial partners interested in utilizing Starship for their own space-based ventures.

        As SpaceX continues to refine and improve the Starship system, the company remains focused on its ultimate goal: establishing a sustainable human presence on Mars. This successful test flight represents not just a technological achievement, but a crucial milestone in humanity's journey to become a spacefaring civilization.
    ''',
    publishTime: DateTime.now(),
  ),
  BlogPost(
    id: '3',
    authorName: 'Bill Gates',
    authorImage: 'assets/blog/profile.png',
    title: 'Breakthrough In Renewable Energy Could Change The World',
    images: ['assets/blog/content.png', 'assets/blog/content2.png'],
    content: '''
        Scientists have made a groundbreaking discovery in renewable energy technology that could fundamentally transform our approach to sustainable power generation. This innovative breakthrough, developed through international collaboration, promises to significantly reduce global dependence on fossil fuels while making clean energy more accessible and affordable for communities worldwide.

        The new technology centers around an advanced form of solar energy capture that dramatically improves efficiency rates beyond current limitations. By utilizing novel materials and quantum mechanics principles, researchers have created a system that can harvest a broader spectrum of solar energy, even in low-light conditions. This advancement could revolutionize how we think about and implement solar power solutions.

        One of the most promising aspects of this discovery is its potential for scalability. The materials used are abundant and relatively inexpensive, making mass production viable. Initial cost analyses suggest that implementing this technology could reduce the price of renewable energy systems by up to 60%, making clean energy more accessible to developing nations and remote communities.

        The environmental implications of this breakthrough cannot be overstated. Early projections indicate that widespread adoption of this technology could reduce global carbon emissions by billions of tons annually. This reduction would play a crucial role in meeting international climate goals and mitigating the effects of climate change.

        The development team has also focused on practical applications, ensuring the technology can be integrated into existing power infrastructure. This compatibility with current systems means that the transition to this new technology could be relatively smooth and cost-effective for utilities and energy providers.

        Beyond environmental benefits, the economic potential of this breakthrough is substantial. The renewable energy sector already employs millions worldwide, and this advancement could create numerous new jobs in manufacturing, installation, and maintenance. Additionally, the technology's efficiency could make energy-intensive industries more sustainable and economically viable.

        As the world continues to grapple with energy security and environmental challenges, this breakthrough represents a beacon of hope. The combination of improved efficiency, reduced costs, and environmental benefits could accelerate the global transition to renewable energy, creating a more sustainable and equitable future for all.
    ''',
    publishTime: DateTime.now(),
  ),
  BlogPost(
    id: '4',
    authorName: 'Jeff Bezos',
    authorImage: 'assets/blog/profile.png',
    title: 'Amazon Unveils AI-Powered Shopping Experience',
    images: ['assets/blog/content.png', 'assets/blog/content2.png'],
    content: '''
        Amazon has introduced a revolutionary AI-powered shopping experience that promises to transform how consumers interact with online retail. This cutting-edge system leverages advanced machine learning algorithms to create highly personalized recommendations and streamline the entire shopping process, marking a significant evolution in e-commerce technology.

        The new AI system analyzes multiple factors, including browsing history, purchase patterns, and real-time behavior, to create a uniquely tailored shopping experience for each user. This sophisticated approach goes beyond simple product recommendations, incorporating contextual understanding to anticipate customer needs and preferences with unprecedented accuracy.

        One of the most innovative features is the AI's ability to understand and adapt to seasonal and lifestyle changes. The system can recognize when customers are preparing for specific life events or seasonal activities, adjusting its recommendations accordingly. This dynamic responsiveness ensures that suggested products remain relevant and valuable to users throughout their evolving needs.

        Security and privacy have been paramount in the development of this new system. Amazon has implemented state-of-the-art encryption and data protection measures, ensuring that personal information remains secure while still delivering highly personalized experiences. Users have complete control over their data preferences and can customize the level of personalization they receive.

        The impact on the shopping experience extends to the platform's search and discovery functions. The AI-powered system introduces more intuitive navigation and natural language processing capabilities, making it easier for customers to find exactly what they're looking for, even with complex or nuanced search queries.

        Early testing has shown remarkable results, with significant improvements in customer satisfaction and engagement. Users report finding desired products more quickly and discovering new items that genuinely interest them. The system has also demonstrated success in reducing cart abandonment rates and increasing customer retention.

        As Amazon continues to refine and expand this AI-powered shopping experience, the company remains committed to incorporating user feedback and evolving the system to meet changing consumer needs. This development represents a significant step forward in the evolution of e-commerce, setting new standards for personalized online shopping.
    ''',
    publishTime: DateTime.now(),
  ),
  BlogPost(
    id: '5',
    authorName: 'Mark Zuckerberg',
    authorImage: 'assets/blog/profile.png',
    title: 'Meta’s Vision For The Future Of Virtual Reality',
    images: ['assets/blog/content.png', 'assets/blog/content2.png'],
    content: '''
        Meta has unveiled its ambitious vision for the future of virtual reality technology, showcasing groundbreaking advancements that promise to revolutionize how we interact, work, and entertain ourselves in digital spaces. This comprehensive update represents a significant leap forward in making immersive digital experiences more accessible and engaging for mainstream users.

        The company's latest developments focus on solving key challenges that have historically limited VR adoption. New breakthrough technologies in haptic feedback allow users to experience a more natural sense of touch and physical presence in virtual environments. This enhanced sensory experience marks a crucial step toward creating truly immersive digital interactions.

        Meta's advances in display technology have also achieved remarkable improvements in visual fidelity. The new generation of VR headsets features significantly higher resolution, wider field of view, and reduced latency, effectively eliminating many of the common complaints about earlier VR systems. These improvements help reduce eye strain and motion sickness, making extended VR sessions more comfortable and enjoyable.

        The social aspects of virtual reality have received particular attention in Meta's new vision. The company has developed sophisticated avatar systems that can accurately reflect users' expressions and body language in real-time, creating more natural and engaging social interactions in virtual spaces. This technology has implications far beyond gaming, potentially transforming how we conduct remote meetings and social gatherings.

        One of the most significant announcements involves Meta's commitment to developing practical applications for VR in professional settings. New tools for virtual collaboration enable teams to work together in shared spaces, manipulate 3D models in real-time, and conduct training simulations with unprecedented realism. These developments could fundamentally change how many industries approach remote work and professional training.

        The company has also made substantial progress in making VR more accessible to developers and content creators. New development tools and platforms make it easier for creators to build immersive experiences, potentially leading to an explosion of innovative VR applications and content in the coming years.

        As Meta continues to push the boundaries of what's possible in virtual reality, their vision extends beyond current technological limitations to imagine a future where digital and physical realities seamlessly integrate. This long-term perspective demonstrates the company's commitment to shaping the future of human interaction in the digital age.
    ''',
    publishTime: DateTime.now(),
  ),
  BlogPost(
    id: '6',
    authorName: 'Sundar Pichai',
    authorImage: 'assets/blog/profile.png',
    title: 'Google’s AI Breakthrough In Medical Research',
    images: ['assets/blog/content.png', 'assets/blog/content2.png'],
    content: '''
        Google has announced a revolutionary breakthrough in medical research powered by artificial intelligence, marking a significant milestone in the intersection of technology and healthcare. The company's DeepMind division has developed an AI system capable of analyzing medical scans with unprecedented accuracy and speed, potentially transforming how diseases are diagnosed and treated.

        The new AI model demonstrates remarkable capabilities in analyzing various types of medical imaging, including X-rays, MRIs, and CT scans. Early testing shows that the system can detect subtle abnormalities that might be missed by human observers, potentially enabling earlier diagnosis of serious conditions. This early detection capability could significantly improve treatment outcomes for many patients.

        One of the most impressive aspects of this breakthrough is the AI's ability to learn and adapt from new data while maintaining patient privacy. The system uses advanced federated learning techniques, allowing it to improve its capabilities without directly accessing sensitive patient information. This approach addresses crucial concerns about data privacy in healthcare technology.

        The development team worked closely with medical professionals throughout the research process, ensuring that the AI system would complement rather than replace human expertise. The result is a tool that enhances doctors' capabilities, providing them with additional insights and helping them make more informed decisions about patient care.

        Clinical trials of the system have shown promising results across multiple medical specialties. In oncology, the AI has demonstrated particular success in identifying early-stage cancers, while in cardiology, it has shown remarkable accuracy in predicting potential heart problems before they become critical.

        The economic implications of this breakthrough are significant. By enabling earlier detection and more accurate diagnosis, the system could help reduce healthcare costs while improving patient outcomes. This efficiency could be particularly valuable in regions with limited access to specialist medical care.

        Looking ahead, Google plans to expand the system's capabilities and make it more widely available to healthcare providers worldwide. This development represents a significant step forward in the company's mission to use technology to improve global health outcomes and make quality healthcare more accessible to all.
    ''',
    publishTime: DateTime.now(),
  ),
  BlogPost(
    id: '7',
    authorName: 'Tim Cook',
    authorImage: 'assets/blog/profile.png',
    title: 'Apple’s New iOS Update Brings Exciting Features',
    images: ['assets/blog/content.png', 'assets/blog/content2.png'],
    content: '''
        Apple has released its latest iOS update, introducing a comprehensive suite of new features and improvements that significantly enhance the iPhone user experience. This update represents one of the most substantial operating system overhauls in recent years, bringing innovative functionality while maintaining Apple's commitment to privacy and security.

        The update introduces sophisticated AI-powered tools that transform how users interact with their devices. New machine learning capabilities enable more intelligent photo organization, enhanced predictive text, and smarter app suggestions. These features adapt to individual usage patterns, creating a more personalized and efficient user experience.

        Battery optimization has received significant attention in this update. Through advanced power management algorithms and improved background app processing, users can expect notably longer battery life across all iPhone models. The system now provides more detailed insights into battery usage, helping users understand and optimize their device's power consumption.

        Security enhancements form a crucial part of the update, with Apple introducing new privacy features that give users greater control over their data. The improved App Privacy Report provides more detailed information about how apps use permissions, while new encryption features further protect sensitive information like health data and messages.

        The update also brings significant improvements to core iOS apps. The Messages app now includes powerful editing capabilities and enhanced group chat features. Maps has been upgraded with more detailed navigation and immersive city experiences, while Weather now offers more accurate predictions and detailed atmospheric data.

        For developers, the update includes new APIs and tools that enable the creation of more sophisticated and engaging applications. These improvements are expected to lead to a new wave of innovative apps that take full advantage of the iPhone's capabilities.

        Early user feedback has been overwhelmingly positive, with many praising the update's stability and performance improvements. The combination of new features, enhanced security, and improved efficiency demonstrates Apple's ongoing commitment to providing the best possible mobile experience for its users.
    ''',
    publishTime: DateTime.now(),
  )
]; 