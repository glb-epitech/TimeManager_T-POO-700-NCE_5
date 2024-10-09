describe('ClockManager', () => {
    beforeEach(() => {
      // Accéder à la page contenant le composant ClockManager
      cy.visit('/')
    })
  
    it('devrait commencer et arrêter de travailler', () => {
      // Vérifier que l'utilisateur n'est pas clocké au début
      cy.get('button').contains('Commencer le travail').should('be.visible')
  
      // Cliquer sur le bouton pour commencer à travailler
      cy.get('button').contains('Commencer le travail').click()
  
      // Vérifier que le texte a changé et montre que l'utilisateur travaille
      cy.contains('Vous êtes en train de travailler depuis').should('be.visible')
      cy.get('button').contains('Arrêter le travail').should('be.visible')
  
      // Cliquer sur le bouton pour arrêter de travailler
      cy.get('button').contains('Arrêter le travail').click()
  
      // Vérifier que le texte indique que l'utilisateur a arrêté
      cy.contains('Vous n\'êtes pas actuellement en train de travailler').should('be.visible')
      cy.get('button').contains('Commencer le travail').should('be.visible')
    })
  
    it('devrait rafraîchir l\'état', () => {
      // Simuler que l'utilisateur a commencé à travailler
      cy.get('button').contains('Commencer le travail').click()
  
      // Vérifier que l'utilisateur est clocké
      cy.contains('Vous êtes en train de travailler depuis').should('be.visible')
  
      // Cliquer sur le bouton de rafraîchissement
      cy.get('button').contains('Rafraîchir').click()
  
      // Vérifier que l'état a été réinitialisé
      cy.contains('Vous n\'êtes pas actuellement en train de travailler').should('be.visible')
    })
  })
  