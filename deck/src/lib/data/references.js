/**
 * Source unique de vérité pour les citations affichées dans les decks.
 * Doit rester synchronisée avec static/references.bib — un test le vérifie.
 * Toute entrée a été vérifiée à la source: ne rien ajouter de mémoire.
 */
export const REFERENCES = {
  turing1950: {
    court: 'Turing 1950',
    auteurs: 'A. M. Turing',
    titre: 'Computing Machinery and Intelligence',
    detail: 'Mind, LIX(236), 433–460',
    lien: 'https://doi.org/10.1093/mind/LIX.236.433'
  },
  mccarthy1955: {
    court: 'McCarthy et al. 1955',
    auteurs: 'J. McCarthy, M. Minsky, N. Rochester, C. Shannon',
    titre: 'A Proposal for the Dartmouth Summer Research Project on Artificial Intelligence',
    detail: 'Réimprimé dans AI Magazine, 27(4), 2006',
    lien: 'https://doi.org/10.1609/aimag.v27i4.1904'
  },
  legg2007: {
    court: 'Legg et Hutter 2007',
    auteurs: 'S. Legg, M. Hutter',
    titre: 'A Collection of Definitions of Intelligence',
    detail: 'Advances in Artificial General Intelligence · arXiv:0706.3639',
    lien: 'https://arxiv.org/abs/0706.3639'
  },
  jordan2015: {
    court: 'Jordan et Mitchell 2015',
    auteurs: 'M. I. Jordan, T. M. Mitchell',
    titre: 'Machine learning: Trends, perspectives, and prospects',
    detail: 'Science, 349(6245), 255–260',
    lien: 'https://doi.org/10.1126/science.aaa8415'
  },
  wang2019: {
    court: 'Wang 2019',
    auteurs: 'P. Wang',
    titre: 'On Defining Artificial Intelligence',
    detail: 'Journal of Artificial General Intelligence, 10(2)',
    lien: 'https://doi.org/10.2478/jagi-2019-0002'
  },
  russell2020: {
    court: 'Russell et Norvig 2020',
    auteurs: 'S. Russell, P. Norvig',
    titre: 'Artificial Intelligence: A Modern Approach',
    detail: '4ᵉ édition, Pearson',
    lien: 'https://aima.cs.berkeley.edu/'
  },
  bengio2003: {
    court: 'Bengio et al. 2003',
    auteurs: 'Y. Bengio, R. Ducharme, P. Vincent, C. Jauvin',
    titre: 'A Neural Probabilistic Language Model',
    detail: 'Journal of Machine Learning Research, 3, 1137–1155',
    lien: 'https://www.jmlr.org/papers/v3/bengio03a.html'
  },
  bahdanau2015: {
    court: 'Bahdanau et al. 2015',
    auteurs: 'D. Bahdanau, K. Cho, Y. Bengio',
    titre: 'Neural Machine Translation by Jointly Learning to Align and Translate',
    detail: 'ICLR 2015 · arXiv:1409.0473',
    lien: 'https://arxiv.org/abs/1409.0473'
  },
  krizhevsky2012: {
    court: 'Krizhevsky et al. 2012',
    auteurs: 'A. Krizhevsky, I. Sutskever, G. E. Hinton',
    titre: 'ImageNet Classification with Deep Convolutional Neural Networks',
    detail: 'NIPS 2012',
    lien: 'https://papers.nips.cc/paper/4824-imagenet-classification-with-deep-convolutional-neural-networks'
  },
  vaswani2017: {
    court: 'Vaswani et al. 2017',
    auteurs: 'A. Vaswani, N. Shazeer, N. Parmar et al.',
    titre: 'Attention Is All You Need',
    detail: 'NeurIPS 2017 · arXiv:1706.03762',
    lien: 'https://arxiv.org/abs/1706.03762'
  },
  brown2020: {
    court: 'Brown et al. 2020',
    auteurs: 'T. B. Brown, B. Mann, N. Ryder et al.',
    titre: 'Language Models are Few-Shot Learners',
    detail: 'NeurIPS 2020 · arXiv:2005.14165',
    lien: 'https://arxiv.org/abs/2005.14165'
  },
  techcrunch2025: {
    court: 'TechCrunch 2025',
    auteurs: 'M. Zeff',
    titre: 'xAI gets permits for 15 natural gas generators at Memphis data center',
    detail: 'TechCrunch, 3 juillet 2025 · permis pour 15 turbines, jusqu’à 35 en service sans permis',
    lien: 'https://techcrunch.com/2025/07/03/xai-gets-permits-for-15-natural-gas-generators-at-memphis-data-center'
  },
  nvidia2024: {
    court: 'NVIDIA 2024',
    auteurs: 'NVIDIA',
    titre: "NVIDIA Ethernet Networking Accelerates World's Largest AI Supercomputer, Built by xAI",
    detail: 'nvidianews.nvidia.com · Colossus, Memphis : 100 000 GPU Hopper, bâti en 122 jours',
    lien: 'https://nvidianews.nvidia.com/news/spectrum-x-ethernet-networking-xai-colossus'
  },
  li2023: {
    court: 'Li et al. 2023',
    auteurs: 'P. Li, J. Yang, M. A. Islam, S. Ren',
    titre: 'Making AI Less "Thirsty": Uncovering and Addressing the Secret Water Footprint of AI Models',
    detail: "arXiv:2304.03271 · 700 000 litres évaporés pour l'entraînement de GPT-3",
    lien: 'https://arxiv.org/abs/2304.03271'
  },
  chiang2024: {
    court: 'Chiang et al. 2024',
    auteurs: 'W.-L. Chiang, L. Zheng, Y. Sheng et al.',
    titre: 'Chatbot Arena: An Open Platform for Evaluating LLMs by Human Preference',
    detail: 'arXiv:2403.04132 · plus de 240 000 votes appariés',
    lien: 'https://arxiv.org/abs/2403.04132'
  },
  dodge2021: {
    court: 'Dodge et al. 2021',
    auteurs: 'J. Dodge, M. Sap, A. Marasović et al.',
    titre: 'Documenting Large Webtext Corpora: A Case Study on the Colossal Clean Crawled Corpus',
    detail: 'EMNLP 2021, p. 1286-1305 · sites les plus représentés de C4, figure 2',
    lien: 'https://aclanthology.org/2021.emnlp-main.98/'
  },
  ahia2023: {
    court: 'Ahia et al. 2023',
    auteurs: 'O. Ahia, S. Kumar, H. Gonen et al.',
    titre: 'Do All Languages Cost the Same? Tokenization in the Era of Commercial Language Models',
    detail: 'EMNLP 2023, p. 9904-9923 · surcoût de tokenisation et qualité moindre',
    lien: 'https://aclanthology.org/2023.emnlp-main.614/'
  },
  touvron2023: {
    court: 'Touvron et al. 2023',
    auteurs: 'H. Touvron, T. Lavril, G. Izacard et al.',
    titre: 'LLaMA: Open and Efficient Foundation Language Models',
    detail: 'arXiv:2302.13971 · composition du corpus, tableau 1',
    lien: 'https://arxiv.org/abs/2302.13971'
  },
  yang2023: {
    court: 'Yang et al. 2023',
    auteurs: 'J. Yang, H. Jin, R. Tang et al.',
    titre: 'Harnessing the Power of LLMs in Practice: A Survey on ChatGPT and Beyond',
    detail: 'arXiv:2304.13712 · arbre évolutif des LLM',
    lien: 'https://arxiv.org/abs/2304.13712'
  },
  jones2025: {
    court: 'Jones et Bergen 2025',
    auteurs: 'C. R. Jones, B. K. Bergen',
    titre: 'Large Language Models Pass the Turing Test',
    detail: 'arXiv:2503.23674',
    lien: 'https://arxiv.org/abs/2503.23674'
  }
};

export const ORDRE_BIBLIO = [
  'turing1950',
  'mccarthy1955',
  'bengio2003',
  'legg2007',
  'krizhevsky2012',
  'bahdanau2015',
  'jordan2015',
  'vaswani2017',
  'techcrunch2025',
  'nvidia2024',
  'li2023',
  'chiang2024',
  'dodge2021',
  'ahia2023',
  'touvron2023',
  'wang2019',
  'russell2020',
  'brown2020',
  'yang2023',
  'jones2025'
];
