// @ts-check
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

// https://astro.build/config
export default defineConfig({
	site: 'https://hoop71.github.io',
	base: '/alexANTria',
	integrations: [
		starlight({
			title: 'alexANTria',
			description: 'RLM architecture for project-scale context. Prevent context rot with three-pool documentation.',
			social: [
				{ icon: 'github', label: 'GitHub', href: 'https://github.com/hoop71/alexANTria' },
			],
			sidebar: [
				{
					label: 'Start Here',
					items: [
						{ label: 'Overview', slug: 'index' },
						{ label: 'RLM Architecture', slug: 'rlm-architecture' },
					],
				},
				{
					label: 'Core Framework',
					items: [
						{ label: 'ANT-FRAMEWORK', slug: 'ant-framework' },
						{ label: 'ANT-SCHEMA', slug: 'ant-schema' },
					],
				},
				{
					label: 'Implementation',
					autogenerate: { directory: 'implementation' },
				},
				{
					label: 'Blog & Articles',
					autogenerate: { directory: 'blog' },
				},
			],
			customCss: [
				// Relative path to your custom CSS file
				'./src/styles/custom.css',
			],
		}),
	],
});
